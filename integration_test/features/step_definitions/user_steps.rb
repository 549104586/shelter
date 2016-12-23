假定(/^(.*)登录$/) do |u|
  u = u.delete '用户'

  user = (users[u] ||= next_user)
  login_as user
end

当(/^访问(.*)$/) do |page|
  case page
  when '首页'
    visit '/'
  end
end

那么(/^显示(.*)链接$/) do |label|
  links = find_link label
  expect(links).to_not be_nil
end

假定(/^创建用户(.*)$/) do |u|
  u.split(',').each do |user|
    sign_up(user.strip)
  end
end

假定(/(.*)创建用户组(.*)/) do |u,g|
  do_as u do
    create_group g
  end
end

假定(/用户(.*)加入用户组(.*)/) do |u,g|
  user = users[u]
  group = groups[g]
  add_user_to_group user,group
end

那么(/^显示用户组(.*)$/) do |g|
  link = find_link groups[g]
  expect(link).to_not be_nil
end

当(/^以(.*)为关键字执行搜索$/) do |s|
  visit "/search?utf8=✓&q=#{s}"
end


那么(/^搜索结果包括镜像(.*)$/) do |imgs|
  _images = imgs.split(',')
  expect( check_seach_result_for( imgs: _images ) ).to be(true)
end

那么(/^搜索结果不包括镜像(.*)$/) do |imgs|
  _images = imgs.split(',')
  expect( check_seach_result_for( imgs: _images ) ).to be(false)
end


那么(/^搜索结果包括用户组(.*)$/) do |groups|
  _groups =  groups.split(',')
  expect( check_seach_result_for( groups: _groups ) ).to be(true)
end



那么(/^搜索结果包括：镜像(\d+)个，用户组(\d+)个$/) do |img, g|
  image_links = page.links.select{|link| link.href =~ /\/n\/[a-zA-Z.0-9_\-]+\/r\/[a-zA-Z.0-9_\-]+/ }
  expect(image_links.size).to be(img.to_i)

  group_links = page.links.select{|link| link.href =~ /\/n\/[a-zA-Z.0-9_\-]+$/ }
  expect(group_links.size).to be >= g.to_i
end

