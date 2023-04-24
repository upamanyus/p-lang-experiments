spec Agreement observes eCommit {
  // NOTE: no sum or option type.
  var isCommitted: bool;
  var committedVal: data;
  start state Init {
    on eCommit do (val: data) {
      if (isCommitted) {

        assert (committedVal == val), "inconsistent values committed. " +
        format("old {0} != new {1}", committedVal, val);
      }
      committedVal = val;
      isCommitted = true;
    }
  }
}

spec Termination observes eCommit {
  start hot state Init {
    on eCommit goto Done;
  }

  state Done {
    on eCommit goto Done;
  }
}
