/* This file contains three different model checking scenarios */

// assert the properties for the single client and single server scenario
test tcThreeReplicas [main=TestWithThreeReplicas]:
  assert Agreement, Termination in
  (union Replica, Proposer, { TestWithThreeReplicas });
