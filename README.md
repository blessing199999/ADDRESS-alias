# ADDRESS Alias System
A Clarity smart contract for registering immutable, human-readable aliases (usernames) to blockchain addresses.
## Purpose
This contract allows any blockchain address to register a single, unique alias. Aliases are readable, immutable, and publicly queryable.

## Features

- **One-to-one mapping:**  
  - One address can own only one alias  
  - One alias can belong to only one address
- **Immutability:**  
  - Aliases cannot be changed once registered
- **Public read access:**  
  - Anyone can query alias/address information
- **Beginner-friendly design:**  
  - Clear separation of concerns  
  - Safe Clarity patterns  
  - Easy to test with Clarinet

## Rules

1. One address can own only ONE alias
2. One alias can belong to only ONE address
3. Aliases are immutable once registered
4. Anyone can read alias information

## Error Codes

- `u100` - Sender already owns an alias
- `u101` - Alias already taken
- `u102` - Alias is empty

## Contract Functions

### Public (State-Changing)

- `register-alias (alias)`  
  Register a new alias for the sender.  
  Returns `(ok alias)` on success, or `(err u100|u101|u102)` on failure.

### Read-Only

- `get-alias (who)`  
  Returns the alias owned by a given address, or `none`.

- `get-address (alias)`  
  Returns the address that owns a given alias, or `none`.

- `has-alias (who)`  
  Returns `true` if the address owns an alias, otherwise `false`.

## Data Storage

- `address-to-alias`  
  Maps addresses to their registered alias.

- `alias-to-address`  
  Maps aliases to their owning address.

## Usage Example

```clarity
;; Register an alias
(contract-call? .ADDRESS-alias register-alias "alice")

;; Get alias for an address
(contract-call? .ADDRESS-alias get-alias 'SP123...')

;; Get address for an alias
(contract-call? .ADDRESS-alias get-address "alice")

;; Check if an address has an alias
(contract-call? .ADDRESS-alias has-alias 'SP123...')
```

## Testing

This contract is designed for easy testing with [Clarinet](https://docs.stacks.co/docs/clarinet/overview/).
