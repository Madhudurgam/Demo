using System;
using System.Collections.Generic;
using System.Data;
using System.Data.Entity;
using System.Data.Entity.Infrastructure;
using System.Linq;
using System.Net;
using System.Net.Http;
using System.Threading.Tasks;
using System.Web.Http;
using System.Web.Http.Description;
using demo_git.Models;

namespace demo_git.Controllers
{
    public class Employee_700Controller : ApiController
    {
        private TRAIN_GIT db = new TRAIN_GIT();

        // GET: api/Employee_700
        public IQueryable<Employee_700> GetEmployee_700()
        {
            return db.Employee_700;
        }

        // GET: api/Employee_700/5
        [ResponseType(typeof(Employee_700))]
        public async Task<IHttpActionResult> GetEmployee_700(int id)
        {
            Employee_700 employee_700 = await db.Employee_700.FindAsync(id);
            if (employee_700 == null)
            {
                return NotFound();
            }

            return Ok(employee_700);
        }
        [HttpGet]
        [Route("getempdata")]
        public IEnumerable<Employee_700>data()
        {
            var data = db.Employee_700.ToList();
            return data;
        }
        // PUT: api/Employee_700/5
        [ResponseType(typeof(void))]
        public async Task<IHttpActionResult> PutEmployee_700(int id, Employee_700 employee_700)
        {
            if (!ModelState.IsValid)
            {
                return BadRequest(ModelState);
            }

            if (id != employee_700.userid)
            {
                return BadRequest();
            }

            db.Entry(employee_700).State = EntityState.Modified;

            try
            {
                await db.SaveChangesAsync();
            }
            catch (DbUpdateConcurrencyException)
            {
                if (!Employee_700Exists(id))
                {
                    return NotFound();
                }
                else
                {
                    throw;
                }
            }

            return StatusCode(HttpStatusCode.NoContent);
        }

        // POST: api/Employee_700
        [ResponseType(typeof(Employee_700))]
        public async Task<IHttpActionResult> PostEmployee_700(Employee_700 employee_700)
        {
            if (!ModelState.IsValid)
            {
                return BadRequest(ModelState);
            }

            db.Employee_700.Add(employee_700);
            await db.SaveChangesAsync();

            return CreatedAtRoute("DefaultApi", new { id = employee_700.userid }, employee_700);
        }

        // DELETE: api/Employee_700/5
        [ResponseType(typeof(Employee_700))]
        public async Task<IHttpActionResult> DeleteEmployee_700(int id)
        {
            Employee_700 employee_700 = await db.Employee_700.FindAsync(id);
            if (employee_700 == null)
            {
                return NotFound();
            }

            db.Employee_700.Remove(employee_700);
            await db.SaveChangesAsync();

            return Ok(employee_700);
        }

        protected override void Dispose(bool disposing)
        {
            if (disposing)
            {
                db.Dispose();
            }
            base.Dispose(disposing);
        }

        private bool Employee_700Exists(int id)
        {
            return db.Employee_700.Count(e => e.userid == id) > 0;
        }
    }
}