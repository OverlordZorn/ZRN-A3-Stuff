Performance Comperisons

```sqf
_test = objNull;
isNull _test; // Execution Time: 0.0005 ms  |  Cycles: 10000/10000  |  Total Time: 5 ms
test isEqualTo objNull; // Execution Time: 0.0006 ms  |  Cycles: 10000/10000  |  Total Time: 6 ms
```