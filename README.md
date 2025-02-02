# Subscription Rebilling service

This is a Ruby-based system for handling automatic subscription rebilling. It retries payments in case of insufficient funds and schedules partial rebills for remaining balances.

## Features
- Retries payments up to 4 times with decreasing amounts (100%, 75%, 50%, 25%).
- Schedules partial rebills for remaining balances one week later.
- Logs all rebilling attempts and results.

## Requirements
- Ruby 3.3.6
- Sinatra
- Bundler
- Redis (for Sidekiq)

## Setup
1. Clone the repository:
   ```bash
   git clone https://github.com:transfer76/subscription_rebilling.git
   cd subscription_rebilling
   ```
2. Install dependencies:
   ```bash
   bundle install
   ```
3. Start the mock payment gateway:
   ```bash
   ruby app/controllers/mock_payment_gateway.rb
   ```
4. Start the Sinatra app:
   ```bash
   ruby  app/controllers/app.rb
   ```
5. Start Sidekiq:
   ```bash
   bundle exec sidekiq -r ./workers/partial_rebill_worker.rb
   ```
## API Endpoints
   - POST /rebill: Initiates the rebilling process.
     - Request body:
     ```json
     {
       "subscription_id": "sub_12345",
       "amount": 1000
     }
     ```
     - Responses:
     ```json
     {
       "message": "Rebill process initiated"
     }
     ```
## Testing
Run the tests using the following command:
```bash
rspec
```
Expected output will confirm if all tests pass successfully.

Rubocop
```bash
bundle exec rubocop
```
## Logs
All rebilling attempts and results are logged in **logs/rebill.log
Examples of logs:
```
# Logfile created on 2025-02-01 19:39:17 +0200 by logger.rb/v1.6.5
I, [2025-02-01T20:11:24.910733 #50933]  INFO -- : PAYMENT_REQUEST. Uri: https://example.com/paymentIntents/create, Params: null, Response: {"status":"success"}
I, [2025-02-01T20:11:24.913253 #50933]  INFO -- : PAYMENT_REQUEST. Uri: https://example.com/paymentIntents/create, Params: null, Response: {"status":"insufficient_funds"}
I, [2025-02-01T20:18:39.735914 #51648]  INFO -- : PAYMENT_REQUEST. Uri: https://example.com/paymentIntents/create, Params: null, Response: {"status":"failed"}
W, [2025-02-02T00:19:53.878155 #78327]  WARN -- : Insufficient funds to charge 1000 for subscription sub_12345
I, [2025-02-02T00:19:53.882006 #78327]  INFO -- : Scheduling partial rebill of 250 for subscription sub_12345 in one week.
```
## Contributing
Pull requests are welcome! For major changes, please open an issue first to discuss the changes.
