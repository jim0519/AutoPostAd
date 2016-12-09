using System;
using System.Collections.Generic;
using System.ComponentModel;
using System.Data;
using System.Drawing;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Windows.Forms;
using AutoPostAdBusiness.Handlers;
using AutoPostAdBusiness;
using System.Threading;
using Common;
using System.Net;
using AutoPostAdBusiness.BusinessModels;
using System.Collections;
using Common.Infrastructure;


namespace AutoPostAd
{
    public partial class AutoPostGumtreeAd : Form
    {
        private AutoPostAdController _manager;
        private EventWaitHandle _WaitHandle = new AutoResetEvent(false);
        private bool _isDeletePost = false;
        public AutoPostGumtreeAd()
        {
            InitializeComponent();

            #region Progress process handling
            ProgressInfoService.ProgressProcessStarted += new EventHandler<ProgressProcessEventArgs>(ProgressInfoService_ProgressProcessStarted);
            ProgressInfoService.ProgressProcessEnded += new EventHandler(ProgressInfoService_ProgressProcessEnded);
            #endregion
        }

        #region Progress process handling

        void ProgressInfoService_ProgressProcessStarted(object sender, ProgressProcessEventArgs e)
        {
            Action actProcessStart = new Action(() => 
            {
                btnPostAd.Enabled = false;
                btnSaveData.Enabled = false;
                btnDeleteAd.Enabled = false;
                pnlProcess.Visible = true;
                btnDAndP.Enabled = false;
                lblProcessInfo.Text = "Process started.";

            });
            this.Invoke(actProcessStart);

            BackgroundWorker worker = new BackgroundWorker();
            worker.DoWork += new DoWorkEventHandler(worker_DoWork);
            worker.RunWorkerCompleted +=worker_RunWorkerCompleted;
            worker.RunWorkerAsync(e);
        }

        private void worker_RunWorkerCompleted(object sender, RunWorkerCompletedEventArgs e)
        {
            //ProgressInfoService.ProgressChanged -= new ProgressChangedEventHandler(ProgressInfoService_ProgressChanged);
            //ProgressInfoService.ProgressCanceledQuery -= new CancelEventHandler(ProgressInfoService_ProgressCanceledQuery);

            //Action<bool> setPanelVisibilityMethod = SetPanelVisibility;
            //this.Invoke(setPanelVisibilityMethod, false);
        }

        void SetPanelVisibility(bool visible)
        {
            //if (!visible)
            //    MessageBox.Show("Process Complete.");
            pnlProcess.Visible = visible;
        }


        void worker_DoWork(object sender, DoWorkEventArgs e)
        {
            //Action<bool> setPanelVisibilityMethod = SetPanelVisibility;
            //this.Invoke(setPanelVisibilityMethod, true);

            ProgressInfoService.ProgressChanged += new ProgressChangedEventHandler(ProgressInfoService_ProgressChanged);
            ProgressInfoService.ProgressCanceledQuery += new CancelEventHandler(ProgressInfoService_ProgressCanceledQuery);
        }

        void ProgressInfoService_ProgressProcessEnded(object sender, EventArgs e)
        {
            Action actProcessEnd = new Action(() => 
            {
                btnPostAd.Enabled = true;
                btnSaveData.Enabled = true;
                btnDeleteAd.Enabled = true;
                pnlProcess.Visible = false;
                btnDAndP.Enabled = true;
                BindDataSource();
                //MessageBox.Show("Complete");
            });
            this.Invoke(actProcessEnd);
            ProgressInfoService.ProgressChanged -= new ProgressChangedEventHandler(ProgressInfoService_ProgressChanged);
            ProgressInfoService.ProgressCanceledQuery -= new CancelEventHandler(ProgressInfoService_ProgressCanceledQuery);
            if (_isDeletePost)
            {
                _isDeletePost = false;
                _manager.PostAd();
            }
        }

        void ProgressInfoService_ProgressChanged(object sender, ProgressChangedEventArgs e)
        {
            Action<int, object> setProgressMethod = SetProgress;
            this.Invoke(setProgressMethod, e.ProgressPercentage, e.UserState);
        }

        void ProgressInfoService_ProgressCanceledQuery(object sender, CancelEventArgs e)
        {

        }

        public void SetProgress(int ProgressPercentage, object Message)
        {
            if (ProgressPercentage >= 0)
            {
                progressBar.Value = ProgressPercentage;
                
                //progressBar.Refresh();
            }

            if (Message != null)
            {
                var message = Message as Dictionary<string, object>;
                if (message["ProgressMessage"] != null)
                {
                    lblProcessInfo.Text = message["ProgressMessage"].ToString();
                    //label1.Refresh();
                }

                if (message.ContainsKey("VerificationImage") && message["VerificationImage"] != null)
                {
                    VerificationControlVisibility(true);


                    picVerificationCode.Image = message["VerificationImage"] as Bitmap ;
                    //pictureBox1.Refresh();
                }
                else
                {
                    VerificationControlVisibility(false);
                }
            }

            foreach (Control c in this.Controls)
            {
                c.Refresh();
            }
            //if (ProgressPercentage != 100)
            //{
            //    pnlProcess.Visible = true;
            //}
            //else
            //{
            //    MessageBox.Show("Process Complete.");
            //    pnlProcess.Visible = false;
                
            //}
        }

        private void VerificationControlVisibility(bool isVisible)
        {
            picVerificationCode.Visible = isVisible;
            txtVerificationCode.Visible = isVisible;
            btnContinuePost.Visible = isVisible;
        }

        #endregion

        private void FillForm()
        {
            _manager = AutoPostAdContext.Instance.Resolve<AutoPostAdController>();

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
           
            dataGridView1.DataSource =null;
            //dataGridView1.DataSource = _manager.DataSource.Where(x => x.GetType().GetProperty(cboSearch.SelectedItem.ToString()).GetValue(x).ToString().ToLowerInvariant().Contains(txtSearch.Text.Trim().ToLowerInvariant()));
            var filteredSource=from data in _manager.DataSource
                               where cboSearch.SelectedItem != null ? (chkAccurate.Checked ? data.GetType().GetProperty(cboSearch.SelectedItem.ToString()).GetValue(data).ToString().ToLowerInvariant() == txtSearch.Text.Trim().ToLowerInvariant() : data.GetType().GetProperty(cboSearch.SelectedItem.ToString()).GetValue(data).ToString().ToLowerInvariant().Contains(txtSearch.Text.Trim().ToLowerInvariant())) : true
                               select data;
            //_manager.DataSource.Where(x => !filteredSource.Contains(x)).ToList().ForEach(x => x.Selected = false);
            dataGridView1.DataSource = filteredSource.ToList();                 
        }
        


        private void btnSearch_Click(object sender, EventArgs e)
        {
            BindDataSource();
        }

        private void AutoPostAd_Load(object sender, EventArgs e)
        {
            FillForm();
        }

        private void BindGrid()
        { 
            
        }

        private void dataGridView1_RowEnter(object sender, DataGridViewCellEventArgs e)
        {
            //MessageBox.Show("Row Enter");
        }

        private void dataGridView1_RowLeave(object sender, DataGridViewCellEventArgs e)
        {
            //MessageBox.Show("Row Leave");
        }

        private void dataGridView1_CellEnter(object sender, DataGridViewCellEventArgs e)
        {
            //MessageBox.Show("Cell Enter");
        }

        private void dataGridView1_CellLeave(object sender, DataGridViewCellEventArgs e)
        {

        }

        private void dataGridView1_RowStateChanged(object sender, DataGridViewRowStateChangedEventArgs e)
        {
            //MessageBox.Show(e.Row.State.ToString());
             
        }

        private void btnSaveData_Click(object sender, EventArgs e)
        {
            _manager.SaveAutoPostAdPostData();
        }

        private void btnPostData_Click(object sender, EventArgs e)
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

        private void btnContinuePost_Click(object sender, EventArgs e)
        {
            VerificationControlVisibility(false);
            _manager.ContinuePostProcess(txtVerificationCode.Text.Trim());
        }

        private void cboSelectAll_CheckedChanged(object sender, EventArgs e)
        {
            //if (chkSelectAll.Checked)
            //{
                foreach (DataGridViewRow dgvr in dataGridView1.Rows)
                {
                    dgvr.Cells[0].Value = chkSelectAll.Checked;
                }
            //}
        }

        private void btnDeleteAd_Click(object sender, EventArgs e)
        {
            _manager.DeleteAd();
        }

        private void cboSelect_CheckedChanged(object sender, EventArgs e)
        {
            //dataGridView1.Rows.OfType<DataGridViewRow>().Where(r=>r.Selected||r.).ToList().ForEach(x =>
            //{
            //    x.Cells["selectedDataGridViewCheckBoxColumn"].Value = cboSelect.Checked;
            //});

            dataGridView1.SelectedCells.Cast<DataGridViewCell>()
                                  .Select(cell => cell.RowIndex)
                                  .Distinct().ToList().ForEach(i => dataGridView1.Rows[i].Cells["selectedDataGridViewCheckBoxColumn"].Value = cboSelect.Checked);
        }

        private void btnDAndP_Click(object sender, EventArgs e)
        {
            try
            {
                _isDeletePost = true;
                _manager.DeleteAd();
            }
            catch (Exception ex)
            {
                _isDeletePost = false;
                throw ex;
            }
        }

        private void btnGetCookie_Click(object sender, EventArgs e)
        {
            try
            {
                _manager.GetCookies();
            }
            catch (Exception ex)
            {
                throw ex;
            }
        }

    }
}
