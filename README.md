# vault-super-admin
This is a demo for showing how can Enterprise manage Vault at scale.

Vault as a secret manager, provide many different services, from static KV to dyanmic database/cloud secrets, as well as data protection functions from Format Preserving Encryption to Tokenisation, it also provide key management functions from KMIP to Key Management secrets engine.

Although every secret is important, Vault administrators don't want to manage everyone of them. In fact, some of the secrets are better managed by consumers, eg static KV.  Vault services can be classified into three groups, 1. stricly managed by Vault administrators, for example, the PKI secret engine. 2. strictly managed by consumer, eg, static KV. 3. something in between.

This repository shows how to manage all those resources.

