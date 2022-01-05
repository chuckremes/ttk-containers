require "tzinfo"
Eastern_TZ = TZInfo::Timezone.get("US/Eastern")
Central_TZ = TZInfo::Timezone.get("US/Central")

require_relative "containers/product/expiration/shared"
require_relative "containers/product/expiration/example"
require_relative "containers/product/shared"
require_relative "containers/product/example"
require_relative "containers/quote/shared"
require_relative "containers/quote/example"
require_relative "containers/leg/shared"
require_relative "containers/leg/example"
require_relative "containers/legs/shared"
require_relative "containers/legs/example"

require_relative "containers/combo/group"
require_relative "containers/combo/shared"
