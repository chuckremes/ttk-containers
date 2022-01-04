module TTK
  module Containers
    module Combo
      class Group
        # Use a bunch of Ruby group_by magic. Sequence of work is to group by:
        #  1. Symbol
        #  2. Type (call, put, equity)
        #  3. expiration_date
        #  4. execution_date # may need to revisit this choice since it doesn't lead to best outcomes in all situations
        #
        # Should create a structure that looks like this:
        #
        # { "SPY" => {
        #       :call => {
        #       },
        #       :put => {
        #          "20211115" => {
        #                   "20211101" => [
        #                                   option1a, option1b, option4a, option4b
        #                                 ],
        #                   "20211102" => [ option2a ]
        #          }
        #          "20211117" => {
        #                   "20211101" => [
        #                                   option3a, option3b
        #                                 ],
        #                   "20211102" => [ option2b ]
        #          },
        #       },
        #       :equity => {
        #       }}}
        #
        # Will result in: VerticalSpread(option1a, option1b)
        #                 VerticalSpread(option3a, option3b)
        #                 VerticalSpread(option4a, option4b)
        #                 CalendarSpread(option2a, option2b)
        #
        # If more than 2 options are in a group at the end, separate long and short and
        # order by strike. Then pair them up 1 for 1, e.g. shorts [460, 459, 455] and
        # longs [430, 429, 425] as [460, 430], [459, 429], [455, 425]. Works for calls
        # and puts.
        #
        # As options get paired up from a grouping, they are removed from the group
        # until only singletons exist. The remaining singletons are then regrouped.
        # Any singletons after that final attempt aer left as standalone legs.
        #
        def self.regroup(list)
          pairs = []
          singles = []
          remainder = []

          z = list.group_by { |l| l.symbol }.transform_values do |v1|
            v1.group_by { |b| b.expiration_date }.transform_values do |v2|
              v2.group_by { |c| c.execution_time }.transform_values do |v3|
                v3.group_by { |d| d.callput }.values.each do |y|
                  # inside here call another method that takes this array
                  # and figures it out, e.g. split shorts & longs and zip them
                  # together
                  pair_sides_together(y, pairs, singles)
                end
              end
            end
          end
          # out here, we need to run over the array one more time and identify the single elements
          # and try to match them up one last time... maybe just zip them together like we do
          # the stuff inside the final grouping
          # anything left over would be a singleton
          pair_sides_together(singles, pairs, remainder)
          # pp 'singles', singles, 'pairs', pairs, 'remainder', remainder
          (pairs + remainder).map { |group| PositionContainer.new(group) } # Legs::Position now
        end

        def self.group_by(array, field)
          array.group_by { |e| e.send(field) }
        end

        def self.sort_by(array, field, direction: :ascending)
          dir = direction == :ascending ? 1 : -1
          (array || []).sort_by { |e| dir * e.send(field) }
        end

        def self.pair_sides_together(group, pairs, singles)
          # pp 'pair_sides_together', 'group', group, 'singles', singles, 'pairs', pairs
          sides = group_by(group, :side)
          shorts = sort_by(sides[:short], :strike, direction: :descending)
          longs = sort_by(sides[:long], :strike, direction: :descending)

          # zip them together
          [shorts.size, longs.size].min.times do
            short, long = shorts.shift, longs.shift
            pairs << [short, long]
          end

          # save whatever is left as a single
          singles.concat(shorts)
          singles.concat(longs)
          # p 'saving unpaired', singles, shorts, longs
        end
      end
    end
  end
end
