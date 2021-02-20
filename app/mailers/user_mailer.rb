# class UserMailer < ApplicationMailer
#   attr_accessor :email,:title,:name
#   def user_mail(email,title,name)      #仮引数に@付きのインスタンス変数は指定できませんので注意
#     @email = email                       #インスタンス変数に格納
#     @title = title                       #インスタンス変数に格納
#     @name  = name                        #インスタンス変数に格納
#     mail  to: @email,                    #メールの宛先を指定
#           subject: "【テストメール】#{@title}" #メールのタイトルを指定
#   end
# end
