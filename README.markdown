Cross Time calculation [![Build Status](https://travis-ci.org/mvj3/cross_time_calculation.png)](https://travis-ci.org/mvj3/cross_time_calculation)
==================================================
If you want to compute the same user's online time from server log, who comes from multiple clients, so you need to remove duplicate parts.

Installation
--------------------------------------------------
```zsh
gem install cross_time_calculation
```

Usage
--------------------------------------------------

```ruby
require 'time'
require 'cross_time_calculation'

@t1 = DateTime.parse("20130512").to_time
@t2 = @t1 + 33
@ctc = CrossTimeCalculation.new
@ctc.add @t1, @t2

@ctc.total_seconds # => 33
```

See more complicated example in unit test
