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

## Contributing
Pull requests are welcome! For major changes, please open an issue first to discuss the changes.
