class UserMismatchError < StandardError
  def message
    "This account is already associated with a different user"
    # TODO: figure out what to do if a user e.g. signs in with facebook for the first time,
    # creating a new user in the process, logs out, signs in with tumblr for the first time,
    # creating another new user in the process, then tries to log in with
    # the same facebook account as before.
    # This would result in the creation of two User instances that are associated
    # with a single person
    # Perhaps there should be some way to merge User instances in this case?
  end
end