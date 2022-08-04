User.delete_all
UserComment.delete_all
UserRegisterInfo.delete_all
UserLoginHistory.delete_all
UserCare.delete_all
VerifyCode.delete_all
Blog.delete_all

User.create({
              nick_name: "全栈学堂系统（demo）",
              score: 99999,
              uid: "111111",
              invite_code: "111111",
              phone: "12345678901",
              head_img: "https://img.177weilai.com/default/logo300.png",
              bg_img: "https://img.177weilai.com/default/sys_bg2.png",
              info: "全栈学堂系统（demo）info",
              info_long: "全栈学堂系统（demo）info_long",
            })

9.times.each do |i|
  User.create({
                nick_name: "学员#{i + 1}",
                score: 1000,
                uid: "10000#{i + 1}",
                invite_code: "10000#{i + 1}",
                phone: "1000000000#{i + 1}",
                head_img: "https://img.177weilai.com/af02ac40-139b-11ed-947c-3d17e1b096ab__w200.png",
                bg_img: "https://img.177weilai.com/da53bc80-10d6-11ed-9162-b7d696f948bb__w400.png",
                info: "学开发就来全栈学堂quanzhan1024.com",
                info_long: "大家好，我是全栈学堂的学员#{i + 1}，学全栈开发，就来全栈学堂 www.quanzhan1024.com。学全栈开发，就来全栈学堂 www.quanzhan1024.com。",
              },)
end

User.all.each do |u|
    Blog.create!({
                   title: '',
                   user_id: u.id,
                   flags: '',
                   content: "学全栈开发，就来全栈学堂 www.quanzhan1024.com。",
                   imgs: 'https://img.177weilai.com/da53bc80-10d6-11ed-9162-b7d696f948bb.png,https://img.177weilai.com/8d7c9420-0c8c-11ed-96fd-ebd4021e2af5.png',
                   category: 'md',
                   type: 'dynamic',
                   o_id: 0,
                   o_type: '',
                 })
    Blog.create!({
                   title: '',
                   user_id: u.id,
                   flags: '',
                   content: "快来全栈学堂，这里能学到真正的实战开发技术",
                   imgs: 'https://img.177weilai.com/cc3a9f20-0752-11ed-a504-7d98f03328a8.png,https://img.177weilai.com/3b6dfdb0-03ed-11ed-ab47-3569576e7ec2.jpg',
                   category: 'md',
                   type: 'dynamic',
                   o_id: 0,
                   o_type: '',
                 })
end