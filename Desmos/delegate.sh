#!/bin/bash


# Note this script adds and modify several scripts found online and parts of the credit goes to the authors

##############################################################################################################################################################
# User settings.
##############################################################################################################################################################

DENOM="udaric"                           # Coin denominator is uatom ("microdaric"). 1 daric = 1000000 udaric.
MINIMUM_DELEGATION_AMOUNT="25000000"     # Only perform delegations above this amount of udaric. Default: 25daric.
RESERVATION_AMOUNT="1000000"             # Keep this amount of uatom in account. Default: 10daric.

VALIDATOR="desmosvaloper....."
WALLET_ADDRS="desmos...."
WALLET_NAME=""

##############################################################################################################################################################


##############################################################################################################################################################
# Sensible defaults.
##############################################################################################################################################################

CHAIN_ID=$(curl -s http://localhost:26657/status | jq -r '.result.node_info.network')            # Current chain id. Empty means auto-detect.
GAS_PRICES="0.01udaric"                                                                          # Gas prices to pay for transaction.
GAS_ADJUSTMENT="1.50"                                                                            # Adjustment for estimated gas
GAS_FLAGS="--gas auto --gas-prices ${GAS_PRICES}  --gas-adjustment ${GAS_ADJUSTMENT}"

##############################################################################################################################################################

echo "Wallet password:"
read -s password


while true;
do
  echo -e "${password}" | desmos tx distribution withdraw-all-rewards  --yes --from ${WALLET_NAME} --chain-id "${CHAIN_ID}"  --broadcast-mode=sync
  sleep 60


  echo -e "${password}" | desmos tx distribution withdraw-rewards ${VALIDATOR} --commission --yes --from ${WALLET_NAME}  --chain-id "${CHAIN_ID}"  --broadcast-mode=sync
  sleep 60

  AMOUNT=$(desmos query bank balances ${WALLET_ADDRS} --chain-id "${CHAIN_ID}" --output=json | jq -r '.balances[].amount')
  echo "Amount being managed:"
  echo "$AMOUNT"


  # Calculate net balance and amount to delegate.
  if [ "${AMOUNT}" -gt $((${MINIMUM_DELEGATION_AMOUNT} + ${RESERVATION_AMOUNT})) ]
    then
       DELEGATION_AMOUNT=$((${AMOUNT} - ${RESERVATION_AMOUNT}))
       echo "Amount being delegated:"
       echo "$DELEGATION_AMOUNT"
       echo -e "${password}" | desmos tx staking delegate ${VALIDATOR} ${DELEGATION_AMOUNT}${DENOM} --yes --from ${WALLET_NAME} --chain-id "${CHAIN_ID}"
    else
       echo "Not enough to delegate"
 fi

  #Wait for an hour:
  sleep 3600
done
