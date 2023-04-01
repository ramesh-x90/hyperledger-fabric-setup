# Ubuntu

# apk add --update --no-cache go git make musl-dev curl

# apk add --update --no-cache docker docker-compose

sudo apt update

sudo apt install docker.io docker-compose

# download go 
curl -sSLO https://go.dev/dl/go1.20.2.linux-amd64.tar.gz

# install go
sudo rm -rf /usr/local/go && sudo tar -C /usr/local -xzf go1.20.2.linux-amd64.tar.gz

# install jq
sudo apt install -y jq



# set env path to go bin
export PATH=$PATH:/usr/local/go/bin



mkdir -p $HOME/go/src/github.com/rameshx90
cd $HOME/go/src/github.com/rameshx90
curl -sSLO https://raw.githubusercontent.com/hyperledger/fabric/main/scripts/install-fabric.sh && chmod +x install-fabric.sh

# install binary, samples, docker images
./install-fabric.sh d s b


# install binary, samples, docker images for specific version
./install-fabric.sh --fabric-version 2.2.1 binary

cd fabric-samples/test-network

# Up network
./network.sh up

# Down network
./network.sh down


docker ps -a


# create channel

./fabric-samples/test-network/network.sh createChannel -c channel11

export PATH=${PWD}/../bin:$PATH
export FABRIC_CFG_PATH=$PWD/../config/


export CORE_PEER_TLS_ENABLED=true
export CORE_PEER_LOCALMSPID="Org1MSP"
export CORE_PEER_TLS_ROOTCERT_FILE=${PWD}/organizations/peerOrganizations/org1.example.com/peers/peer0.org1.example.com/tls/ca.crt
export CORE_PEER_MSPCONFIGPATH=${PWD}/organizations/peerOrganizations/org1.example.com/users/Admin@org1.example.com/msp
export CORE_PEER_ADDRESS=localhost:7051

#  start a chaincode on the channel
./network.sh deployCC -ccn basic -ccp ../asset-transfer-basic/chaincode-go -ccl go


# initialize the ledger with assets. (Note the CLI does not access the Fabric Gateway peer, so each endorsing peer must be specified.)
peer chaincode invoke -o localhost:7050 --ordererTLSHostnameOverride orderer.example.com --tls --cafile "${PWD}/organizations/ordererOrganizations/example.com/orderers/orderer.example.com/msp/tlscacerts/tlsca.example.com-cert.pem" -C mychannel -n basic --peerAddresses localhost:7051 --tlsRootCertFiles "${PWD}/organizations/peerOrganizations/org1.example.com/peers/peer0.org1.example.com/tls/ca.crt" --peerAddresses localhost:9051 --tlsRootCertFiles "${PWD}/organizations/peerOrganizations/org2.example.com/peers/peer0.org2.example.com/tls/ca.crt" -c '{"function":"InitLedger","Args":[]}'
