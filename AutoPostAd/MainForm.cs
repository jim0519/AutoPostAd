using System;
using System.Collections.Generic;
using System.ComponentModel;
using System.Data;
using System.Drawing;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Windows.Forms;
using System.Reflection;
using Common;

namespace AutoPostAd
{
    public partial class MainForm : Form
    {
        public MainForm()
        {
            InitializeComponent();
            foreach (ToolStripItem item in msMenu.Items)
            {
                if (AutoPostAdConfig.Instance.ActiveForms.Contains(item.Text))
                {
                    item.Visible = true;
                }
                else
                {
                    item.Visible = false;
                }
            }
        }

        

        private void gumtreeAdToolStripMenuItem_Click(object sender, EventArgs e)
        {
            ShowForm("AutoPostAd.AutoPostGumtreeAd");
        }

        private void quickSaleAdToolStripMenuItem_Click(object sender, EventArgs e)
        {
            ShowForm("AutoPostAd.AutoPostQuickSalesAd");
        }

        private void MainForm_Load(object sender, EventArgs e)
        {
            gumtreeAdToolStripMenuItem_Click(null, null);
        }

        private void ShowForm(string formFullName)
        {
            var existingForm = this.MdiChildren.FirstOrDefault(f => f.Name.Equals(GetFormName(formFullName)));
            if (existingForm != null)
            {
                existingForm.Visible = true;
                this.Width = existingForm.Width + 30;
                this.Height = existingForm.Height + 27;
                existingForm.Activate();
            }
            else
            {
                var tempAssembly = Assembly.GetExecutingAssembly();
                //Type t = tempAssembly.GetType(formName);
                
                //object o = System.Activator.CreateInstance(t, null);
                var frm = tempAssembly.CreateInstance(formFullName) as Form;
                //var frm = new AutoPostAd();
                frm.MdiParent = this;
                this.Width = frm.Width + 30;
                this.Height = frm.Height + 27;
                frm.WindowState = FormWindowState.Maximized;
                frm.Show();
            }
        }

        private string GetFormName(string formFullName)
        {
            if (!string.IsNullOrEmpty(formFullName))
            {
                return formFullName.Substring(formFullName.LastIndexOf(".") + 1, formFullName.Length - (formFullName.LastIndexOf(".") + 1));
            }
            return string.Empty;
        }
    }

}
