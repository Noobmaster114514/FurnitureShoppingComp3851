using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Mvc;
using FurnitureShopping.Models; //需要先引用模型类

namespace FurnitureShopping.Controllers
{
    public class LoginController : Controller
    {
        //使用数据库上下文对象操作
        private FurnitureProjectDBEntities db = new FurnitureProjectDBEntities();
        // 登录
        public ActionResult Index()
        {
            return View();
        }

        //实现的是Post请求
        [HttpPost]
        public ActionResult Index(string username,string pwd)
        {
            //1、判断用户名和密码是否为空
            if (string.IsNullOrEmpty(username))
            {
                return Content("<script>alert('Username cannot be empty！');window.history.back(-1);</script>");
            }
            if (string.IsNullOrEmpty(pwd))
            {
                return Content("<script>alert('Password cannot be empty！');window.history.back(-1);</script>");
            }
            admin info = db.admin.FirstOrDefault(p=>p.username == username && p.pwd == pwd);
            if(info == null)
            {
                return Content("<script>alert('Incorrect Username or Password！');window.history.back(-1);</script>");
            }
            else
            {
                //使用Session记住用户的关键信息
                Session["nickname"] = info.nickname;
                Session["id"] = info.id;
                return Redirect("/Admin/Index"); //代表登录成功
            }
            return View();
        }

        //退出系统
        public ActionResult Logout()
        {
            Session["nickname"] = null;
            Session["id"] = null;
            return Redirect("/Home/Index");
        }
    }
}