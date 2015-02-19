current_valuation = 0
current_valuation1 = 0
current_karma = 0


SCHEDULER.every '2s' do
  last_valuation = current_valuation
  last_valuation1 = current_valuation1
  last_karma     = current_karma
  current_valuation = rand(100)
  current_valuation1 = rand(100)
  current_karma     = rand(200000)

  send_event('valuation', { current: current_valuation, last: last_valuation })
  send_event('karma', { current: current_karma, last: last_karma })
  send_event('synergy',   { value: rand(100) })
  send_event('yahoofinance', { current: current_valuation1, last: last_valuation1 })
end