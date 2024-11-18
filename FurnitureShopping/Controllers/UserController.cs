using System;
using System.Collections.Generic;
using System.Data;
using System.Data.Entity;
using System.Data.Entity.Infrastructure;
using System.IO;
using System.Linq;
using System.Net;
using System.Web;
using System.Web.Mvc;
using FurnitureShopping.Filter;
using FurnitureShopping.Models;

namespace FurnitureShopping.Controllers
{
    [AdminAuthen]
    public class UserController : Controller
    {
        private FurnitureProjectDBEntities db = new FurnitureProjectDBEntities();

        // 用户列表
        public ActionResult Index(string keyword = "")
        {
            return View(db.user.Where(p=>p.nickname.Contains(keyword)).ToList());
        }

        // 查看用户详情
        public ActionResult Details(int? id)
        {
            if (id == null)
            {
                return new HttpStatusCodeResult(HttpStatusCode.BadRequest);
            }
            user user = db.user.Find(id);
            if (user == null)
            {
                return HttpNotFound();
            }
            return View(user);
        }

        // 添加用户
        public ActionResult Create()
        {
            return View();
        }

        // 执行添加操作
        [HttpPost]
        [ValidateAntiForgeryToken]
        public ActionResult Create([Bind(Include = "id,username,pwd,nickname,sex,introduce,age,img")] user user)
        {
            if (ModelState.IsValid)
            {
                db.user.Add(user);
                db.SaveChanges();
                return RedirectToAction("Index");
            }

            return View(user);
        }

        // 编辑
        public ActionResult Edit(int? id)
        {
            if (id == null)
            {
                return new HttpStatusCodeResult(HttpStatusCode.BadRequest);
            }
            user user = db.user.Find(id);
            if (user == null)
            {
                return HttpNotFound();
            }
            return View(user);
        }

        [HttpPost]
        [ValidateAntiForgeryToken]
        public ActionResult Edit([Bind(Include = "id,username,pwd,nickname,sex,introduce,age,img")] user user, HttpPostedFileBase imgFile)
        {
            var existingUser = db.user.AsNoTracking().FirstOrDefault(u => u.id == user.id);
            if (existingUser == null)
            {
                ModelState.AddModelError("", "The user you are trying to edit no longer exists in the database.");
                return View(user);
            }

            if (imgFile != null && imgFile.ContentLength > 0)
            {
                var allowedExtensions = new[] { ".jpg", ".jpeg", ".png", ".gif" };
                string extension = Path.GetExtension(imgFile.FileName).ToLower();

                if (allowedExtensions.Contains(extension))
                {
                    string uploadDir = Server.MapPath("~/Content/Uploads");
                    if (!Directory.Exists(uploadDir))
                    {
                        Directory.CreateDirectory(uploadDir);
                    }

                    try
                    {
                        string fileName = Guid.NewGuid().ToString() + extension;
                        string filePath = Path.Combine(uploadDir, fileName);
                        imgFile.SaveAs(filePath);

                        // 删除旧图片文件（如果存在）
                        if (!string.IsNullOrEmpty(existingUser.img))
                        {
                            string oldFilePath = Server.MapPath(existingUser.img);
                            if (System.IO.File.Exists(oldFilePath))
                            {
                                System.IO.File.Delete(oldFilePath);
                            }
                        }

                        user.img = "/Content/Uploads/" + fileName;
                    }
                    catch (Exception ex)
                    {
                        ModelState.AddModelError("img", "Failed to save the image. " + ex.Message);
                        return View(user); // 显示错误信息并返回视图
                    }
                }
                else
                {
                    ModelState.AddModelError("img", "Invalid file type. Only JPG, JPEG, PNG, and GIF are allowed.");
                    return View(user);
                }
            }

            db.Entry(user).State = EntityState.Modified;
            db.SaveChanges();
            return RedirectToAction("Index");
        }



        //删除用户
        public ActionResult Delete(int id)
        {
            user user = db.user.Find(id);
            db.user.Remove(user);
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
