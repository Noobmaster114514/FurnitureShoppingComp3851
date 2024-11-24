using FurnitureShopping.Filter;
using FurnitureShopping.Models;
using System.Data.Entity;
using System.IO;
using System.Linq;
using System.Threading.Tasks;
using System.Web.Mvc;
using System.Web;
using System;

namespace FurnitureShopping.Controllers
{
    [AdminAuthen]
    public class ProductAttributeController : Controller
    {
        private FurnitureProjectDBEntities db = new FurnitureProjectDBEntities();

        // 商品属性列表
        public ActionResult Index(int? sid)
        {
            if (sid == null)
            {
                return new HttpStatusCodeResult(System.Net.HttpStatusCode.BadRequest, "The 'sid' parameter is required.");
            }

            var dbContext = db.product_attribute.Include(p => p.shopping);
            ViewBag.pid = sid.Value; // 将 sid 的值传递到视图
            return View(dbContext.Where(p => p.pid == sid.Value).OrderByDescending(p => p.id).ToList());
        }

        // 添加属性
        public ActionResult Create(int pid)
        {
            var shoppingItem = db.shopping.FirstOrDefault(p => p.id == pid);
            if (shoppingItem == null)
            {
                return HttpNotFound("The specified product was not found.");
            }

            // 初始化 ViewData 和 ViewBag
            ViewBag.ainfo = new product_attribute { attristock = "0" }; // 假设库存初始值为0
            ViewData["attrimg"] = "/Content/DefaultImage.png"; // 默认图片路径

            return View(shoppingItem);
        }

        // 保存添加
        [HttpPost]
        [ValidateAntiForgeryToken]
        public async Task<ActionResult> Create(product_attribute product_attribute, HttpPostedFileBase attrimg)
        {
            if (ModelState.IsValid)
            {
                // 处理上传的图片文件
                if (attrimg != null && attrimg.ContentLength > 0)
                {
                    string fileSavePath;
                    string error = SaveUploadedFile(attrimg, out fileSavePath);

                    if (error != null)
                    {
                        ModelState.AddModelError("attrimg", error);
                        return View(product_attribute);
                    }

                    // 保存文件路径到数据库中
                    product_attribute.attrimg = fileSavePath;
                }

                db.product_attribute.Add(product_attribute);
                await db.SaveChangesAsync();
                return RedirectToAction("Index", new { sid = product_attribute.pid });
            }
            return View(product_attribute);
        }

        // 编辑
        public ActionResult Edit(int pid, int? id)
        {
            if (id == null)
            {
                return new HttpStatusCodeResult(System.Net.HttpStatusCode.BadRequest);
            }

            var productAttribute = db.product_attribute.Find(id);
            if (productAttribute == null)
            {
                return HttpNotFound();
            }

            var shoppingItem = db.shopping.FirstOrDefault(p => p.id == pid);
            if (shoppingItem == null)
            {
                return HttpNotFound();
            }

            // 使用 ViewBag 传递 productAttribute 数据，包括 attristock
            ViewBag.ainfo = productAttribute;

            return View(shoppingItem);
        }


        // 保存编辑
        [HttpPost]
        [ValidateAntiForgeryToken]
        public async Task<ActionResult> Edit(int id, product_attribute product_attribute, HttpPostedFileBase attrimg)
        {
            if (ModelState.IsValid)
            {
                // 保留原始的 attrimg 如果用户没有上传新的图片
                var originalProductAttribute = db.product_attribute.AsNoTracking().FirstOrDefault(pa => pa.id == id);

                if (originalProductAttribute == null)
                {
                    return HttpNotFound();
                }

                // 如果用户没有上传新的图片，保持原始图片路径
                if (attrimg == null || attrimg.ContentLength == 0)
                {
                    product_attribute.attrimg = originalProductAttribute.attrimg;
                }
                else
                {
                    // 处理上传的图片文件
                    string fileSavePath;
                    string error = SaveUploadedFile(attrimg, out fileSavePath);

                    if (error != null)
                    {
                        ModelState.AddModelError("attrimg", error);
                        return View(product_attribute);
                    }

                    // 更新数据库中的图片路径
                    if (!string.IsNullOrEmpty(originalProductAttribute.attrimg))
                    {
                        DeleteFile(originalProductAttribute.attrimg); // 删除旧文件
                    }
                    product_attribute.attrimg = fileSavePath;
                }

                db.Entry(product_attribute).State = EntityState.Modified;
                await db.SaveChangesAsync();
                return RedirectToAction("Index", new { sid = product_attribute.pid });
            }
            return View(product_attribute);
        }



        // 删除商品属性
        public async Task<ActionResult> Delete(int id)
        {
            var productAttribute = await db.product_attribute.FindAsync(id);
            if (productAttribute != null)
            {
                int? sid = productAttribute.pid; // 确保在删除后传递 sid 的值
                DeleteFile(productAttribute.attrimg); // 删除图片文件
                db.product_attribute.Remove(productAttribute);
                await db.SaveChangesAsync();
                return RedirectToAction("Index", new { sid = sid });
            }
            return RedirectToAction("Index");
        }

        // 文件上传处理
        private string SaveUploadedFile(HttpPostedFileBase file, out string fileSavePath)
        {
            fileSavePath = null;

            var allowedExtensions = new[] { ".jpg", ".jpeg", ".png", ".gif" };
            string extension = Path.GetExtension(file.FileName).ToLower();

            if (!allowedExtensions.Contains(extension))
            {
                return "Invalid file type. Only JPG, JPEG, PNG, and GIF are allowed.";
            }

            string uploadDir = Server.MapPath("~/Content/Uploads");
            if (!Directory.Exists(uploadDir))
            {
                Directory.CreateDirectory(uploadDir);
            }

            string fileName = Guid.NewGuid().ToString() + extension;
            fileSavePath = "/Content/Uploads/" + fileName;
            file.SaveAs(Path.Combine(uploadDir, fileName));

            return null;
        }

        // 删除文件方法
        private void DeleteFile(string filePath)
        {
            if (!string.IsNullOrEmpty(filePath))
            {
                string fullPath = Server.MapPath(filePath);
                if (System.IO.File.Exists(fullPath))
                {
                    System.IO.File.Delete(fullPath);
                }
            }
        }

        // 释放数据库上下文
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
