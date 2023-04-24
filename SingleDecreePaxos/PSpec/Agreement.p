spec Agreement observes eCommit {
  // NOTE: no sum or option type.
  var isCommitted: bool;
  var committedVal: data;
  start state Init {
    on eCommit do (val: data) {
      if (isCommitted) {
        assert (committedVal == val), "inconsistent values committed";
      }
      committedVal = val;
    }
  }
}

spec Termination observes eCommit {
  // NOTE: no sum or option type.
  var isCommitted: bool;
  var committedVal: data;
  start hot state Init {
    on eCommit goto Done;
  }

  state Done {
  }
}
