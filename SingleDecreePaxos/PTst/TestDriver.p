machine TestWithThreeReplicas
{
  start state Init {
    entry {
      var vals: set[int];
      vals += (1); vals += (2); vals += (3);
      SetupSystem(vals, 3);
    }
  }
}

fun SetupSystem(vals: set[data], numProposers: int)
{
  var replicas: set[Replica];
  var val: data;

  // create the replicas
  foreach (val in vals) {
    replicas += (new Replica(val));
  }

  new Proposer(replicas);
}
