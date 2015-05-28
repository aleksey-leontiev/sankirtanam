module Statistics::NewReportHelper
  def user_access_location_name(user)
    cid = user.id
    acc = UserLocationAccess.where{user_id == cid}.first

    if acc != nil then acc.location.name else "" end
  end
end