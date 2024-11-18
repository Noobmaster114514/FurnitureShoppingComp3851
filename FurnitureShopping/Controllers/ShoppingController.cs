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
    public class ShoppingController : Controller
    {
        private FurnitureProjectDBEntities db = new FurnitureProjectDBEntities();

        // 商品管理
        public ActionResult Index(string keyword = "")
        {
            var shopping = db.shopping.Include(s => s.category);
            return View(shopping.Where(p => p.title.Contains(keyword)).OrderByDescending(p => p.id).ToList());
        }

        // 商品详情
        public ActionResult Details(int? id)
        {
            if (id == null)
            {
                return new HttpStatusCodeResult(HttpStatusCode.BadRequest);
            }
            shopping shopping = db.shopping.Find(id);
            if (shopping == null)
            {
                return HttpNotFound();
            }
            return View(shopping);
        }

        // 添加商品
        public ActionResult Create()
        {
            ViewBag.cid = new SelectList(db.category, "id", "catename");
            return View();
        }

        // 保存商品
        [HttpPost]
        [ValidateAntiForgeryToken]
        [ValidateInput(false)]
        public ActionResult Create([Bind(Include = "id,title,cid,price,sale_price,number,detail,img,shop_number")] shopping shopping)
        {
            if (ModelState.IsValid)
            {
                try
                {
                    db.shopping.Add(shopping);
                    db.SaveChanges();
                    return RedirectToAction("Index");
                }
                catch (Exception ex)
                {
                    ModelState.AddModelError("", "Failed to save changes. Error: " + ex.Message);
                }
            }
            else
            {
                ModelState.AddModelError("", "Validation failed. Please check the input fields.");
            }

            ViewBag.cid = new SelectList(db.category, "id", "catename", shopping.cid);
            return View(shopping);
        }


        // 编辑商品
        public ActionResult Edit(int? id)
        {
            if (id == null)
            {
                return new HttpStatusCodeResult(HttpStatusCode.BadRequest);
            }
            shopping shopping = db.shopping.Find(id);
            if (shopping == null)
            {
                return HttpNotFound();
            }
            ViewBag.cid = new SelectList(db.category, "id", "catename", shopping.cid);
            return View(shopping);
        }

        // 保存编辑
        [HttpPost]
        [ValidateAntiForgeryToken]
        [ValidateInput(false)]
        public ActionResult Edit([Bind(Include = "id,title,cid,price,sale_price,number,detail,img,shop_number")] shopping shopping)
        {
            if (ModelState.IsValid)
            {
                db.Entry(shopping).State = EntityState.Modified;
                db.SaveChanges();
                return RedirectToAction("Index");
            }
            ViewBag.cid = new SelectList(db.category, "id", "catename", shopping.cid);
            return View(shopping);
        }
        public ActionResult Delete(int id)
        {
            shopping shopping = db.shopping.Find(id);
            if (shopping == null)
            {
                return HttpNotFound();
            }

            // Check if the product has associated product_attribute items and remove them
            if (shopping.product_attribute != null && shopping.product_attribute.Count > 0)
            {
                // Remove all associated product_attribute items
                foreach (var attr in shopping.product_attribute.ToList())
                {
                    db.product_attribute.Remove(attr);
                }

                db.SaveChanges();  // Save changes to remove all associated product attributes
            }

            // Check if the product is associated with any orders
            if (shopping.order_detail != null && shopping.order_detail.Count > 0)
            {
                // Find the default product, assuming it has a title "default" or adjust based on your default product setup
                var defaultProduct = db.shopping.FirstOrDefault(s => s.title == "default");

                if (defaultProduct != null)
                {
                    // Update all associated order details to reference the default product
                    foreach (var orderDetail in shopping.order_detail.ToList())
                    {
                        orderDetail.aid = defaultProduct.id;  // Set the order detail's product ID to the default product ID
                        db.Entry(orderDetail).State = EntityState.Modified;  // Mark the entity as modified
                    }

                    db.SaveChanges();  // Save changes to update the order details
                    TempData["Message"] = "商品已删除，并且订单中的商品已被设置为默认商品。";
                }
                else
                {
                    TempData["Error"] = "未找到默认商品，无法删除当前商品。";
                    return RedirectToAction("Index");
                }
            }

            // Remove the shopping item
            db.shopping.Remove(shopping);
            db.SaveChanges();

            // Redirect back to the shopping index page
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
