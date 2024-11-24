using System;
using System.Collections.Generic;
using System.Data;
using System.Data.Entity;
using System.Linq;
using System.Net;
using System.Web;
using System.Web.Mvc;
using FurnitureShopping.Filter;
using FurnitureShopping.Models;

namespace FurnitureShopping.Controllers
{
    [AdminAuthen]
    public class AdminsController : Controller
    {
        private FurnitureProjectDBEntities db = new FurnitureProjectDBEntities();

        // 管理员管理
        public ActionResult Index(string keyword = "")
        {
            return View(db.admin.Where(p => p.nickname.Contains(keyword)).ToList());
        }

        // 添加管理员
        public ActionResult Create()
        {
            return View();
        }

        // 保存添加
        [HttpPost]
        [ValidateAntiForgeryToken]
        public ActionResult Create([Bind(Include = "id,username,pwd,nickname,power,createtime")] admin admin)
        {
            if (db.admin.Any(a => a.username == admin.username))
            {
                ModelState.AddModelError("username", "Username already exists.");
            }

            if (ModelState.IsValid)
            {
                admin.createtime = DateTime.Now;  // 自动生成创建时间
                db.admin.Add(admin);
                db.SaveChanges();
                return RedirectToAction("Index");
            }

            return View(admin);
        }

        // 编辑
        public ActionResult Edit(int? id)
        {
            if (id == null)
            {
                return new HttpStatusCodeResult(HttpStatusCode.BadRequest);
            }
            admin admin = db.admin.Find(id);
            if (admin == null)
            {
                return HttpNotFound();
            }
            return View(admin);
        }

        // 保存编辑
        [HttpPost]
        [ValidateAntiForgeryToken]
        public ActionResult Edit([Bind(Include = "id,username,pwd,nickname,power")] admin admin)
        {
            if (ModelState.IsValid)
            {
                var existingAdmin = db.admin.Find(admin.id);
                if (existingAdmin != null)
                {
                    // 保留原来的创建时间
                    admin.createtime = existingAdmin.createtime;

                    // 如果 nickname 是 "superadmin"，保留它
                    if (existingAdmin.nickname == "superadmin")
                    {
                        admin.nickname = existingAdmin.nickname;
                    }

                    // 使用 SetValues 更新除 createtime 以外的字段
                    db.Entry(existingAdmin).CurrentValues.SetValues(admin);
                    db.SaveChanges();

                    return Content("<script>alert('Modification Succeed！');window.history.back(-1);</script>");
                }
                else
                {
                    return HttpNotFound();
                }
            }

            // 打印错误信息以调试
            var errors = ModelState.Values.SelectMany(v => v.Errors);
            foreach (var error in errors)
            {
                System.Diagnostics.Debug.WriteLine("Model Error: " + error.ErrorMessage);
            }

            return View(admin);
        }

        // 修改管理员自己的密码
        public ActionResult updatePwd(int? id)
        {
            if (id == null)
            {
                return new HttpStatusCodeResult(HttpStatusCode.BadRequest);
            }
            admin admin = db.admin.Find(id);
            if (admin == null)
            {
                return HttpNotFound();
            }
            return View(admin);
        }

        // 删除管理员
        public ActionResult Delete(int id)
        {
            admin admin = db.admin.Find(id);
            if (admin == null)
            {
                return HttpNotFound();
            }

            if (admin.nickname == "superadmin")
            {
                return Content("<script>alert('Cannot delete superadmin account.');window.history.back(-1);</script>");
            }

            db.admin.Remove(admin);
            db.SaveChanges();
            return RedirectToAction("Index");
        }

        protected override void Dispose(bool disposing)
        {
            if (disposing)
            {
                db.Dispose();
            }
            base.Dispose(disposing);
        }
    }
}
