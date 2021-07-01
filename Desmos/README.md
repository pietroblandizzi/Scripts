# Desmos automatic delegation script
This script allows automation of daily tasks such as withdraw commissions and rewards and re delegate them to a validator on the Desmos network.

## Prerequisite
I assume you aready have a proper Desmos node and wallet set up. If not please do so following the documentation here: [Desmos doc](https://docs.desmos.network/fullnode/overview.html#requirements)

The only requirement is tmux or any other screen utility.

Install tmux: 
`sudo apt install tmux`

## Add proper info to the script

In order to run the script we would need to add some info about our wallet and operator.
I assume you know your WALLET_NAME and your Wallet password.

* WALLET_NAME: set the name here

* WALLET_ADDRS: here set the 'desmos...' address
You can look for it running: `desmos keys list`


* VALIDATOR: Copy here your 'desmosvaloper' address.
You can get it from the [Explorer](https://morpheus.desmos.network/validators) 
or using this command: `desmos query staking delegations desmos16v6pcp6tjqk9np20jv0zw7wy7ehqy7g3asxt67 --output json | jq`

the 'validator_address` is what you are looking for.`

## Other params

You can:
```
MINIMUM_DELEGATION_AMOUNT: Changing this value will change the minimum amount you need in your wallet to delegate
RESERVATION_AMOUNT: This is the amount that will always be left in your wallet

The script waits 60 sec between commands (you can change the number of seconds).
The script sleep for 1h and then performs the task again (you can change the amount of seconds).
But i would say 1h is good enough
```

## Deploy

Note in this guide i will use tmux please look here for a list of commands: [Tmux](https://tmuxcheatsheet.com/)

1. Move the script on the server where your node is running
2. Give the script the execution rights: `chmod +x delegate.sh`
3. Create a tmux session ` tmux new -s stakingBot` 
4. Inside the session run the script: `./delegate.sh`
The script will ask for your wallet password. Dont worry it will not show on the screen.

Let it run!

In order to detach from the session: `Ctrl+b d`
If u later would like to attach again to the session ` tmux a -t stakingBot`

