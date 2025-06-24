import requests

def get_bitcoin_price():
    url = "https://api.coingecko.com/api/v3/simple/price"
    params = {
        'ids': 'bitcoin',
        'vs_currencies': 'usd'
    }

    try:
        response = requests.get(url, params=params)
        data = response.json()
        price = data['bitcoin']['usd']
        print(f"💰 Price of BTC for today: ${price}")
    except Exception as e:
        print("❌ Error while trying to get BTC price:", e)

if __name__ == "__main__":
    get_bitcoin_price()
