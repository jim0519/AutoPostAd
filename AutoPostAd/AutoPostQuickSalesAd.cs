using System;
using System.Collections.Generic;
using System.ComponentModel;
using System.Data;
using System.Drawing;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Windows.Forms;
using AutoPostAdBusiness;
using AutoPostAdBusiness.Handlers;
using Common.Infrastructure;

namespace AutoPostAd
{
    public partial class AutoPostQuickSalesAd : Form
    {
        private QuickSaleAutoPostAdController _manager;
        public AutoPostQuickSalesAd()
        {
            InitializeComponent();
        }

        private void FillForm()
        {
            _manager = AutoPostAdContext.Instance.Resolve<QuickSaleAutoPostAdController>();

            BindDataSource();
            //var filterRows = _manager.DataSource.Where(x => x.GetType().GetProperty("SKU").GetValue(x).ToString().Contains("EFFECT"));
            //dataGridView1.DataSource = filterRows.ToList();
            //var searchFields = dataGridView1.Columns.Cast<DataGridViewColumn>();
            //var rows = dataGridView1.Rows.Cast<DataGridViewRow>();
            //var q=dataGridView1.Rows.AsQueryable();
            //var row=from dgv in q
            //        select dgv.

            //comboBox1.DataSource = searchFields;
            foreach (var col in dataGridView1.Columns)
            {
                //if(col.GetType()==typeof(DataGridViewTextBoxColumn))
                //{
                string name = ((DataGridViewColumn)col).DataPropertyName;
                cboSearch.Items.Add(name);
                //}
            }

        }

        private void BindDataSource()
        {

            dataGridView1.DataSource = null;
            //dataGridView1.DataSource = _manager.DataSource.Where(x => x.GetType().GetProperty(cboSearch.SelectedItem.ToString()).GetValue(x).ToString().ToLowerInvariant().Contains(txtSearch.Text.Trim().ToLowerInvariant()));
            var filteredSource = from data in _manager.DataSource
                                 where cboSearch.SelectedItem != null ? (chkAccurate.Checked? data.GetType().GetProperty(cboSearch.SelectedItem.ToString()).GetValue(data).ToString().ToLowerInvariant()==txtSearch.Text.Trim().ToLowerInvariant(): data.GetType().GetProperty(cboSearch.SelectedItem.ToString()).GetValue(data).ToString().ToLowerInvariant().Contains(txtSearch.Text.Trim().ToLowerInvariant()) ): true
                                 select data;
            //_manager.DataSource.Where(x => !filteredSource.Contains(x)).ToList().ForEach(x => x.Selected = false);
            dataGridView1.DataSource = filteredSource.OrderBy(x=>x.ID).ToList();
        }

        private void AutoPostQuickSalesAd_Load(object sender, EventArgs e)
        {
            FillForm();
        }

        private void btnSearch_Click(object sender, EventArgs e)
        {
            BindDataSource();
        }

        private void btnDeleteAd_Click(object sender, EventArgs e)
        {
            try
            {
                _manager.DeleteAd();
            }
            catch (Exception ex)
            {
                MessageBox.Show(ex.Message);
            }
        }

        private void btnPostAd_Click(object sender, EventArgs e)
        {
            try
            {
                _manager.PostAd();
            }
            catch (Exception ex)
            {
                MessageBox.Show(ex.Message);
            }
        }

        private void btnSaveData_Click(object sender, EventArgs e)
        {

        }

        private void chkSelectAll_CheckedChanged(object sender, EventArgs e)
        {
            foreach (DataGridViewRow dgvr in dataGridView1.Rows)
            {
                dgvr.Cells[0].Value = chkSelectAll.Checked;
            }
        }

        private void btnReviseInfo_Click(object sender, EventArgs e)
        {
            try
            {
                _manager.ReviseInfo();
            }
            catch (Exception ex)
            {
                MessageBox.Show(ex.Message);
            }
        }

        private void btnRelist_Click(object sender, EventArgs e)
        {
            try
            {
                _manager.RelistAd();
            }
            catch (Exception ex)
            {
                MessageBox.Show(ex.Message);
            }
        }

        private void btnSelectOpposite_Click(object sender, EventArgs e)
        {
            dataGridView1.Rows.OfType<DataGridViewRow>().ToList().ForEach(x =>
            {
                x.Cells["selectedDataGridViewCheckBoxColumn"].Value = !Convert.ToBoolean(x.Cells["selectedDataGridViewCheckBoxColumn"].Value);
            });
        }

        private void btnConvertImageLink_Click(object sender, EventArgs e)
        {
            try
            {
                _manager.ConvertImageLink();
            }
            catch (Exception ex)
            {
                MessageBox.Show(ex.Message);
            }
        }

        private void btnDownloadImages_Click(object sender, EventArgs e)
        {
            try
            {
                _manager.DownloadImages();
            }
            catch (Exception ex)
            {
                MessageBox.Show(ex.Message);
            }
        }

        private void cboSelect_CheckedChanged(object sender, EventArgs e)
        {
            dataGridView1.SelectedCells.Cast<DataGridViewCell>()
                                  .Select(cell => cell.RowIndex)
                                  .Distinct().ToList().ForEach(i => dataGridView1.Rows[i].Cells["selectedDataGridViewCheckBoxColumn"].Value = cboSelect.Checked);
        }

        private void btnGetCategory_Click(object sender, EventArgs e)
        {
            try
            {
                _manager.GetQuickSaleCategoryXML();
            }
            catch (Exception ex)
            {
                MessageBox.Show(ex.Message);
            }
        }
    }
}
