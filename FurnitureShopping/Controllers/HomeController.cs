using System;
using System.Collections.Generic;
using System.Data.Entity;
using System.Diagnostics;
using System.Linq;
using System.Web;
using System.Web.Mvc;
using FurnitureShopping.Filter;
using FurnitureShopping.Models;

namespace FurnitureShopping.Controllers
{
    public class HomeController : Controller
    {
        // 数据库上下文对象
        private FurnitureProjectDBEntities db = new FurnitureProjectDBEntities();

        // 首页
        public ActionResult Index()
        {
            var list = db.shopping.OrderByDescending(p => p.id).Take(12).ToList();
            return View(list);
        }

        // 后台个人中心
        [UserAuthen]
        public ActionResult BackIndex()
        {
            return View();
        }

        // 商品列表页
        public ActionResult List(int? cid, string keyword = "", int page = 1)
        {
            int pageSize = 16;
            IEnumerable<shopping> list = null;

            if (!string.IsNullOrEmpty(keyword))
            {
                list = db.shopping.Where(p => p.title.Contains(keyword)).OrderByDescending(p => p.id).ToList();
            }
            else
            {
                if (cid == null)
                {
                    return Content("<script>alert('Unable to find product！');window.history.back(-1);</script>");
                }
                list = db.shopping.Where(p => p.cid == cid).OrderByDescending(p => p.id).ToList();
            }

            int recordCount = list.Count();
            list = list.Skip((page - 1) * pageSize).Take(pageSize);
            ViewBag.pageNum = Math.Ceiling((Convert.ToDecimal(recordCount)) / pageSize);
            return View(list);
        }

        // 商品详情页
        public ActionResult Detail(int? id)
        {
            if (id == null)
            {
                return Content("<script>alert('Unable to find product！');window.history.back(-1);</script>");
            }

            shopping info = db.shopping.FirstOrDefault(p => p.id == id);
            if (info == null)
            {
                return Content("<script>alert('Unable to find product！');window.history.back(-1);</script>");
            }

            ViewBag.attrList = db.product_attribute.Where(p => p.pid == id).ToList();
            ViewBag.list = db.comment.Where(p => p.shop_id == id).ToList();

            return View(info);
        }

        // 根据规格ID获取商品详情（AJAX接口）
        [HttpPost]
        public JsonResult GetProductDetailsByAttributeId(int attrId)
        {
            var attr = db.product_attribute.Include(p => p.shopping).FirstOrDefault(p => p.id == attrId);
            if (attr == null)
            {
                return Json(new { status = "error", message = "Specification not found!" });
            }

            return Json(new
            {
                status = "success",
                price = attr.price,
                stock = attr.attristock,
                img = attr.attrimg,
                title = attr.shopping.title // Pass the original shopping title instead of attribute title
            });
        }

        // 登录
        public ActionResult Login()
        {
            return View();
        }

        [HttpPost]
        public ActionResult Login(user u)
        {
            user info = db.user.FirstOrDefault(p => p.username == u.username);
            if (info != null)
            {
                if (info.pwd != u.pwd)
                {
                    return Content("<script>alert('Incorrect username or password！');window.history.back(-1);</script>");
                }
                else
                {
                    Session["nick"] = info.nickname;
                    Session["img"] = info.img;
                    Session["user_id"] = info.id;
                    return Redirect("/Home/Index");
                }
            }
            else
            {
                return Content("<script>alert('Incorrect username or password！');window.history.back(-1);</script>");
            }
        }

        // 注册
        public ActionResult Register()
        {
            return View();
        }

        [HttpPost]
        public ActionResult Register(user u)
        {
            user info = db.user.FirstOrDefault(p => p.username == u.username);
            if (info != null)
            {
                return Content("<script>alert('The username already exists！');window.history.back(-1);</script>");
            }
            u.img = "/assets/img/head.png";
            db.user.Add(u);
            db.SaveChanges();
            return Content("<script>alert('Registration Successful！');window.location.href=Request.UrlReferrer != null ? Request.UrlReferrer.ToString() : '/Home/Login';</script>");
        }

        // 退出系统
        public ActionResult Logout()
        {
            Session["nick"] = null;
            Session["user_id"] = null;
            return Redirect("/Home/Index");
        }

        // 支付页面
        [UserAuthen]
        // 支付页面【商品详情页跳转过来的支付】

        public ActionResult Pay2(int shopId, int shopNum, int aid, decimal price, string img)
        {
            int userId = 0;
            if (Session["user_id"] != null)
            {
                userId = int.Parse(Session["user_id"].ToString());
            }

            if (userId == 0)
            {
                return Content("<script>alert('Please login before purchasing an item！');window.location.href=Request.UrlReferrer != null ? Request.UrlReferrer.ToString() : '/Home/Login';</script>");
            }

            // 查询商品信息
            shopping s = db.shopping.FirstOrDefault(p => p.id == shopId);
            if (s == null)
            {
                return Content("<script>alert('Unable to find product！');window.history.back(-1);</script>");
            }

            ViewBag.aid = aid;
            ViewBag.shopNum = shopNum;
            ViewBag.price = price;
            ViewBag.img = img;

            // 我的地址
            ViewBag.address = db.address.Where(p => p.uid == userId).OrderByDescending(p => p.id).ToList();
            return View(s);
        }
        // 执行支付操作
        [UserAuthen]
        [HttpPost]
        public ActionResult Pay2(int address_id, string payWay, string mark, int shopId, int shopNum, int aid, decimal? price, string img)
        {
            if (price == null)
            {
                return Content("Invalid product price!");
            }

            int userId = 0;
            if (Session["user_id"] != null)
            {
                userId = int.Parse(Session["user_id"].ToString());
            }

            // 查询商品详情
            var attr = db.product_attribute.Include(p => p.shopping).FirstOrDefault(p => p.id == aid);
            if (attr != null && int.Parse(attr.attristock) < shopNum)
            {
                return Content("Insufficient stock!");
            }
            else if (attr == null)
            {
                // 如果没有规格属性，检查商品主库存
                var product = db.shopping.FirstOrDefault(p => p.id == shopId);
                if (product == null)
                {
                    return Content("Product not found!");
                }
                if (product.number < shopNum)
                {
                    return Content("Insufficient stock!");
                }
            }

            // 查询用户地址
            var a = db.address.FirstOrDefault(p => p.id == address_id);
            if (a == null)
            {
                return Content("Shipping address not found!");
            }

            // 创建订单
            var o = new order()
            {
                uid = userId,
                order_num = "o" + DateTime.Now.ToString("yyMMddHHmmss"),
                sum_price = price.Value * shopNum,
                mark = mark,
                createtime = DateTime.Now,
                is_pay = 1,
                state = 0,
                pay_way = payWay,
                address_id = address_id,
                address = a.address1,
                phone = a.phone,
                name = a.name
            };
            db.order.Add(o);

            // 创建订单详情
            var d = new order_detail()
            {
                order_id = o.id,
                count = shopNum,
                price = price.Value,
                sum_price = price.Value * shopNum,
                shop_id = shopId,
                title = attr != null ? attr.shopping.title : db.shopping.FirstOrDefault(p => p.id == shopId)?.title,
                aid = aid,
                // 将图片信息添加到订单详情
            };
            db.order_detail.Add(d);

            // 更新库存逻辑
            if (attr != null)
            {
                // 有规格属性，扣减规格库存
                attr.attristock = (int.Parse(attr.attristock) - shopNum).ToString();
                db.Entry(attr).State = EntityState.Modified;
            }
            else
            {
                // 无规格属性，扣减商品主库存
                var product = db.shopping.FirstOrDefault(p => p.id == shopId);
                if (product != null)
                {
                    product.number -= shopNum;
                    db.Entry(product).State = EntityState.Modified;
                }
            }

            // 保存到数据库
            if (db.SaveChanges() > 0)
            {
                return Content("200");
            }
            else
            {
                return Content("201");
            }
        }



        // 获取购物车数据// 获取购物车数据// 获取购物车数据
        [UserAuthen]
        public ActionResult Pay()
        {
            int userId = GetLoggedInUserId();
            if (userId == 0)
            {
                return Content("<script>alert('Please log in first to view your shopping cart!');window.location.href='/Home/Login';</script>");
            }

            // 获取购物车数据
            var cartItems = db.shop_car
                .Include(p => p.shopping)
                .Include(p => p.product_attribute)
                .Where(p => p.uid == userId)
                .OrderByDescending(p => p.id)
                .ToList();

            if (!cartItems.Any())
            {
                return Content("<script>alert('Your shopping cart is empty!');window.history.back();</script>");
            }

            // 获取用户地址
            var addresses = db.address
                .Where(a => a.uid == userId)
                .OrderByDescending(a => a.id)
                .ToList();

            if (!addresses.Any())
            {
                ViewBag.Message = "No addresses found. Please add an address first.";
                ViewBag.address = new List<address>();
            }
            else
            {
                ViewBag.address = addresses;
            }

            // 将购物车数据传递到视图
            return View(cartItems);
        }



        [UserAuthen]
        [HttpPost]
        public ActionResult Pay(int address_id, string payWay, string mark)
        {
            int userId = GetLoggedInUserId();
            if (userId == 0)
            {
                return Content("<script>alert('Please log in first to checkout!');window.location.href='/Home/Login';</script>");
            }

            // 获取购物车数据
            var cartItems = db.shop_car
                .Include(p => p.shopping)
                .Where(p => p.uid == userId)
                .ToList();

            if (!cartItems.Any())
            {
                return Content("<script>alert('Your shopping cart is empty!');window.history.back();</script>");
            }

            // 检查地址是否存在
            var address = db.address.FirstOrDefault(p => p.id == address_id);
            if (address == null)
            {
                return Content("Shipping address not found!");
            }

            using (var transaction = db.Database.BeginTransaction())
            {
                try
                {
                    // 创建订单
                    var order = new order
                    {
                        uid = userId,
                        order_num = "o" + DateTime.Now.ToString("yyMMddHHmmss"),
                        createtime = DateTime.Now,
                        is_pay = 1,
                        state = 0,
                        pay_way = payWay,
                        address_id = address_id,
                        address = address.address1,
                        phone = address.phone,
                        name = address.name,
                        mark = mark
                    };
                    db.order.Add(order);
                    db.SaveChanges(); // 保存订单以获取订单ID

                    decimal totalSum = 0;
                    List<string> errorMessages = new List<string>();

                    foreach (var item in cartItems)
                    {
                        int shopNum = item.shopNum ?? 0;
                        decimal price = 0m;
                        product_attribute attribute = null;

                        // 加载商品属性
                        if (item.aid.HasValue && item.aid.Value > 0)
                        {
                            attribute = db.product_attribute.FirstOrDefault(a => a.id == item.aid.Value);
                            if (attribute != null)
                            {
                                price = attribute.price ?? 0m;

                                // 解析并检查 attristock
                                int currentStock;
                                if (!int.TryParse(attribute.attristock, out currentStock))
                                {
                                    errorMessages.Add($"Invalid stock value for product attribute ID: {attribute.id}");
                                    continue;
                                }

                                if (currentStock < shopNum)
                                {
                                    errorMessages.Add($"Product: {item.shopping?.title ?? "Unknown"} - Attribute: {attribute?.title ?? "Default"} is out of stock.");
                                    continue;
                                }

                                // 减少库存
                                currentStock -= shopNum;
                                attribute.attristock = currentStock.ToString();
                                db.Entry(attribute).State = EntityState.Modified;
                            }
                            else
                            {
                                errorMessages.Add("Product attribute not found.");
                                continue;
                            }
                        }
                        else if (item.shopping != null)
                        {
                            // 无属性，减少产品库存
                            price = item.shopping.sale_price ?? 0m;
                            int stock = item.shopping.number;
                            if (stock < shopNum)
                            {
                                errorMessages.Add($"Product: {item.shopping?.title ?? "Unknown"} is out of stock.");
                                continue;
                            }
                            item.shopping.number = stock - shopNum;
                            db.Entry(item.shopping).State = EntityState.Modified;
                        }
                        else
                        {
                            errorMessages.Add("Product information is missing.");
                            continue;
                        }

                        var itemTotal = price * shopNum;
                        totalSum += itemTotal;

                        // 创建订单详情
                        var orderDetail = new order_detail
                        {
                            order_id = order.id,
                            shop_id = item.shopid ?? 0,
                            aid = item.aid ?? 0,
                            count = shopNum,
                            price = price,
                            sum_price = itemTotal,
                            title = attribute != null
                                ? $"{item.shopping?.title ?? "Unknown"} ({attribute.title})"
                                : item.shopping?.title ?? "Unknown"
                        };
                        db.order_detail.Add(orderDetail);
                    }

                    if (errorMessages.Any())
                    {
                        // 删除创建的订单
                        db.Entry(order).State = EntityState.Deleted;

                        // 回滚事务
                        transaction.Rollback();
                        return Content($"<script>alert('{string.Join("\\n", errorMessages)}');window.history.back();</script>");
                    }

                    // 更新订单总金额
                    order.sum_price = totalSum;
                    db.Entry(order).State = EntityState.Modified;

                    // 清空购物车
                    db.shop_car.RemoveRange(cartItems);

                    // 保存所有更改
                    db.SaveChanges();

                    // 提交事务
                    transaction.Commit();

                    return Content("<script>alert('Payment successful!');window.location.href='/Order/Index2';</script>");
                }
                catch (Exception ex)
                {
                    // 回滚事务
                    transaction.Rollback();
                    // 记录异常日志
                    System.Diagnostics.Debug.WriteLine($"Exception during payment: {ex.Message}");
                    return Content("<script>alert('An error occurred during payment processing!');window.history.back();</script>");
                }
            }
        }



        // 添加到购物车
        [UserAuthen]
        [HttpPost]
        public ActionResult addCar(int shopId, int shopNum, int aid)
        {
            int userId = GetLoggedInUserId();
            if (userId == 0)
            {
                return Json(new { status = "error", message = "Please login first!" });
            }

            // 检查商品库存
            var attr = db.product_attribute.FirstOrDefault(p => p.id == aid);
            if (attr != null && int.Parse(attr.attristock) < shopNum)
            {
                return Json(new { status = "error", message = "Insufficient stock!" });
            }

            // 查询购物车中是否已有该商品
            var cartItem = db.shop_car.FirstOrDefault(p => p.shopid == shopId && p.uid == userId && p.aid == aid);
            if (cartItem != null)
            {
                // 如果存在，增加数量
                cartItem.shopNum += shopNum;
                db.Entry(cartItem).State = EntityState.Modified;
            }
            else
            {
                // 如果不存在，添加新的商品到购物车
                var newItem = new shop_car
                {
                    shopid = shopId,
                    shopNum = shopNum,
                    createtime = DateTime.Now,
                    uid = userId,
                    aid = aid
                };
                db.shop_car.Add(newItem);
            }

            // 保存更改
            if (db.SaveChanges() > 0)
            {
                return Json(new { status = "success", message = "Added to cart successfully!" });
            }
            else
            {
                return Json(new { status = "error", message = "Failed to add to cart!" });
            }
        }

        // 辅助方法：获取登录用户ID
        private int GetLoggedInUserId()
        {
            if (Session["user_id"] != null)
            {
                return int.Parse(Session["user_id"].ToString());
            }
            return 0;
        }


        // 我的购物车
        [UserAuthen]
public ActionResult Car()
{
    int userId = GetLoggedInUserId();
    if (userId == 0)
    {
        return Content("<script>alert('Please log in first to view your shopping cart！');window.location.href='/Home/Login';</script>");
    }

    // 获取用户地址
    var addresses = db.address
        .Where(a => a.uid == userId)
        .OrderByDescending(a => a.id)
        .ToList();

    if (!addresses.Any())
    {
        ViewBag.Message = "No addresses found. Please add an address.";
    }

    ViewBag.address = addresses;

    // 获取购物车数据
    var cartItems = db.shop_car
        .Include(p => p.shopping)
        .Include(p => p.product_attribute)
        .Where(p => p.uid == userId)
        .OrderByDescending(p => p.id)
        .ToList();


    return View(cartItems);
}



      


        // 删除购物车中的商品
        [UserAuthen]
        [HttpPost]
        public ActionResult delCar(int shopId)
        {
            int userId = 0;
            if (Session["user_id"] != null)
            {
                userId = int.Parse(Session["user_id"].ToString());
            }

            shop_car info = db.shop_car.FirstOrDefault(p => p.shopid == shopId && p.uid == userId);
            db.shop_car.Remove(info);

            if (db.SaveChanges() > 0)
            {
                return Content("200");
            }
            else
            {
                return Content("201");
            }
        }

        // 评论功能
        [UserAuthen]
        [HttpPost]
        public ActionResult AddComment(int shop_id, string detail)
        {
            int userId = 0;
            if (Session["user_id"] != null)
            {
                userId = int.Parse(Session["user_id"].ToString());
            }

            var comment = new comment
            {
                shop_id = shop_id,
                uid = userId,
                detail = detail,
                createtime = DateTime.Now
            };
            db.comment.Add(comment);

            if (db.SaveChanges() > 0)
            {
                return Content("200");
            }
            else
            {
                return Content("201");
            }
        }
    }
}
