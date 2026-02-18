# Assignment 1: Data Locations and Behavior in Solidity

## 1. Where are structs, mappings, and arrays stored?

- **Contract Level:** Structs, arrays, and mappings declared at the contract level are always stored in **storage**.
- **Inside Functions:** \* For structs and arrays, the location depends on the keyword specified: `memory`, `storage`, or `calldata`.
    - **Mappings:** Mappings are always in **storage**, regardless of where they are declared.

## 2. How do they behave when executed or called?

- **Storage:** Acts as a **reference**. Modifying the variable **modifies the original** data state.
- **Memory:** Acts as a **copy**. Modifying the variable **does not modify the original** data (changes are temporary).
- **Calldata:** This is a **read-only** external input. It cannot be modified.
- **Mappings:** These are **storage only** and function as reference types.

## 3. Why don't you need to specify memory or storage with mappings?

You do not need to specify the data location for mappings because:

1.  Mappings **cannot exist in memory**; they are strictly a storage concept.
2.  They have **no length** (conceptually infinite).
3.  They use **hashed storage slots** to look up values, which makes them incompatible with how memory is structured in the EVM.
