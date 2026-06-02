# Shanten Calculator

Based on https://github.com/Kraballa/ShantenCalculator


## Diagram

```marmaid
flowchart TD
    E[caller]
    A[shanten.calculate] .-> |n| E --> |tiles| A
    B[shanten.calculate_kokushi] .-> |n| A  --> |tiles| B
    C[shanten.calculate_chiitoitsu] .-> |n| A --> C
    D[shanten.calculate_other_hands] .-> |n| A --> D
    F[analysis.count_terminals_honors] .-> |n, n_pairs| B --> |tiles| F
    G[analysis.count_pairs] .-> |n| C --> |tiles| G
    H[analysis.scan] .-> |n_set, n_p_set, n_pairs| D --> |tiles| H
    I[shanten.from_melds] .-> |n| D --> |n_set, n_p_set, n_pairs| I
    J[analysis.split] .-> |man, pin, sou, z| H --> |tiles| J
    K[meld_finder.count_z] .-> |n_pairs, n_set| H --> |z, n_pairs, n_set| K
    L[meld_finder.count] .-> |n_set, n_p_set, n_pairs| H --> |man, n_set, n_p_set, n_pairs| L
    L .-> |n_set, n_p_set, n_pairs| H --> |pin, n_set, n_p_set, n_pairs| L
    L .-> |n_set, n_p_set, n_pairs| H --> |sou, n_set, n_p_set, n_pairs| L
    M[meld_finder.find] .-> |melds| L --> |tiles| M
    N[meld_finder.find_best_meld_combo] .-> |best_melds| M --> |tiles, best_melds, current_melds| N
    O[meld_finder.find_all_groups] .-> |groups| N --> |tiles| O
    P[meld_finder.small_meld] .-> |meld| O --> |tiles| P
    N --> |tiles, best_melds, current_melds| N
    Q[meld_finder.value_melds] .-> |n| N --> |best_melds| Q
    Q[meld_finder.value_melds] .-> |n| N --> |current_| Q
    I .-> |n| Q --> |n_sets, n_p_sets, n_pairs| I
```
    
