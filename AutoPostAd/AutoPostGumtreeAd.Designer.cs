namespace AutoPostAd
{
    partial class AutoPostGumtreeAd
    {
        /// <summary>
        /// Required designer variable.
        /// </summary>
        private System.ComponentModel.IContainer components = null;

        /// <summary>
        /// Clean up any resources being used.
        /// </summary>
        /// <param name="disposing">true if managed resources should be disposed; otherwise, false.</param>
        protected override void Dispose(bool disposing)
        {
            if (disposing && (components != null))
            {
                components.Dispose();
            }
            base.Dispose(disposing);
        }

        #region Windows Form Designer generated code

        /// <summary>
        /// Required method for Designer support - do not modify
        /// the contents of this method with the code editor.
        /// </summary>
        private void InitializeComponent()
        {
            this.components = new System.ComponentModel.Container();
            this.dataGridView1 = new System.Windows.Forms.DataGridView();
            this.selectedDataGridViewCheckBoxColumn = new System.Windows.Forms.DataGridViewCheckBoxColumn();
            this.sKUDataGridViewTextBoxColumn = new System.Windows.Forms.DataGridViewTextBoxColumn();
            this.priceDataGridViewTextBoxColumn = new System.Windows.Forms.DataGridViewTextBoxColumn();
            this.titleDataGridViewTextBoxColumn = new System.Windows.Forms.DataGridViewTextBoxColumn();
            this.descriptionDataGridViewTextBoxColumn = new System.Windows.Forms.DataGridViewTextBoxColumn();
            this.InventoryQty = new System.Windows.Forms.DataGridViewTextBoxColumn();
            this.LastReturnAdID = new System.Windows.Forms.DataGridViewTextBoxColumn();
            this.Result = new System.Windows.Forms.DataGridViewTextBoxColumn();
            this.ResultMessage = new System.Windows.Forms.DataGridViewTextBoxColumn();
            this.Postage = new System.Windows.Forms.DataGridViewTextBoxColumn();
            this.Notes = new System.Windows.Forms.DataGridViewTextBoxColumn();
            this.UserName = new System.Windows.Forms.DataGridViewTextBoxColumn();
            this.AddressName = new System.Windows.Forms.DataGridViewTextBoxColumn();
            this.ImagesPath = new System.Windows.Forms.DataGridViewTextBoxColumn();
            this.BusinessLogoPath = new System.Windows.Forms.DataGridViewTextBoxColumn();
            this.WebsiteCategoryName = new System.Windows.Forms.DataGridViewTextBoxColumn();
            this.autoPostAdPostDataBMBindingSource = new System.Windows.Forms.BindingSource(this.components);
            this.bindingSource1 = new System.Windows.Forms.BindingSource(this.components);
            this.btnSearch = new System.Windows.Forms.Button();
            this.cboSearch = new System.Windows.Forms.ComboBox();
            this.txtSearch = new System.Windows.Forms.TextBox();
            this.btnSaveData = new System.Windows.Forms.Button();
            this.progressBar = new System.Windows.Forms.ProgressBar();
            this.pnlProcess = new System.Windows.Forms.Panel();
            this.lblProcessInfo = new System.Windows.Forms.Label();
            this.btnContinuePost = new System.Windows.Forms.Button();
            this.txtVerificationCode = new System.Windows.Forms.TextBox();
            this.picVerificationCode = new System.Windows.Forms.PictureBox();
            this.btnPostAd = new System.Windows.Forms.Button();
            this.chkSelectAll = new System.Windows.Forms.CheckBox();
            this.btnDeleteAd = new System.Windows.Forms.Button();
            this.chkAccurate = new System.Windows.Forms.CheckBox();
            this.cboSelect = new System.Windows.Forms.CheckBox();
            this.btnDAndP = new System.Windows.Forms.Button();
            this.btnGetCookie = new System.Windows.Forms.Button();
            ((System.ComponentModel.ISupportInitialize)(this.dataGridView1)).BeginInit();
            ((System.ComponentModel.ISupportInitialize)(this.autoPostAdPostDataBMBindingSource)).BeginInit();
            ((System.ComponentModel.ISupportInitialize)(this.bindingSource1)).BeginInit();
            this.pnlProcess.SuspendLayout();
            ((System.ComponentModel.ISupportInitialize)(this.picVerificationCode)).BeginInit();
            this.SuspendLayout();
            // 
            // dataGridView1
            // 
            this.dataGridView1.AllowUserToOrderColumns = true;
            this.dataGridView1.AutoGenerateColumns = false;
            this.dataGridView1.ColumnHeadersHeightSizeMode = System.Windows.Forms.DataGridViewColumnHeadersHeightSizeMode.AutoSize;
            this.dataGridView1.Columns.AddRange(new System.Windows.Forms.DataGridViewColumn[] {
            this.selectedDataGridViewCheckBoxColumn,
            this.sKUDataGridViewTextBoxColumn,
            this.priceDataGridViewTextBoxColumn,
            this.titleDataGridViewTextBoxColumn,
            this.descriptionDataGridViewTextBoxColumn,
            this.InventoryQty,
            this.LastReturnAdID,
            this.Result,
            this.ResultMessage,
            this.Postage,
            this.Notes,
            this.UserName,
            this.AddressName,
            this.ImagesPath,
            this.BusinessLogoPath,
            this.WebsiteCategoryName});
            this.dataGridView1.DataSource = this.autoPostAdPostDataBMBindingSource;
            this.dataGridView1.Location = new System.Drawing.Point(0, 28);
            this.dataGridView1.Name = "dataGridView1";
            this.dataGridView1.Size = new System.Drawing.Size(1158, 342);
            this.dataGridView1.TabIndex = 0;
            this.dataGridView1.CellEnter += new System.Windows.Forms.DataGridViewCellEventHandler(this.dataGridView1_CellEnter);
            this.dataGridView1.CellLeave += new System.Windows.Forms.DataGridViewCellEventHandler(this.dataGridView1_CellLeave);
            this.dataGridView1.RowEnter += new System.Windows.Forms.DataGridViewCellEventHandler(this.dataGridView1_RowEnter);
            this.dataGridView1.RowLeave += new System.Windows.Forms.DataGridViewCellEventHandler(this.dataGridView1_RowLeave);
            this.dataGridView1.RowStateChanged += new System.Windows.Forms.DataGridViewRowStateChangedEventHandler(this.dataGridView1_RowStateChanged);
            // 
            // selectedDataGridViewCheckBoxColumn
            // 
            this.selectedDataGridViewCheckBoxColumn.DataPropertyName = "Selected";
            this.selectedDataGridViewCheckBoxColumn.HeaderText = "Selected";
            this.selectedDataGridViewCheckBoxColumn.Name = "selectedDataGridViewCheckBoxColumn";
            this.selectedDataGridViewCheckBoxColumn.Width = 60;
            // 
            // sKUDataGridViewTextBoxColumn
            // 
            this.sKUDataGridViewTextBoxColumn.DataPropertyName = "SKU";
            this.sKUDataGridViewTextBoxColumn.HeaderText = "SKU";
            this.sKUDataGridViewTextBoxColumn.Name = "sKUDataGridViewTextBoxColumn";
            // 
            // priceDataGridViewTextBoxColumn
            // 
            this.priceDataGridViewTextBoxColumn.DataPropertyName = "Price";
            this.priceDataGridViewTextBoxColumn.HeaderText = "Price";
            this.priceDataGridViewTextBoxColumn.Name = "priceDataGridViewTextBoxColumn";
            // 
            // titleDataGridViewTextBoxColumn
            // 
            this.titleDataGridViewTextBoxColumn.DataPropertyName = "Title";
            this.titleDataGridViewTextBoxColumn.HeaderText = "Title";
            this.titleDataGridViewTextBoxColumn.Name = "titleDataGridViewTextBoxColumn";
            // 
            // descriptionDataGridViewTextBoxColumn
            // 
            this.descriptionDataGridViewTextBoxColumn.DataPropertyName = "Description";
            this.descriptionDataGridViewTextBoxColumn.HeaderText = "Description";
            this.descriptionDataGridViewTextBoxColumn.Name = "descriptionDataGridViewTextBoxColumn";
            // 
            // InventoryQty
            // 
            this.InventoryQty.DataPropertyName = "InventoryQty";
            this.InventoryQty.HeaderText = "InventoryQty";
            this.InventoryQty.Name = "InventoryQty";
            // 
            // LastReturnAdID
            // 
            this.LastReturnAdID.DataPropertyName = "LastReturnAdID";
            this.LastReturnAdID.HeaderText = "LastReturnAdID";
            this.LastReturnAdID.Name = "LastReturnAdID";
            this.LastReturnAdID.ReadOnly = true;
            // 
            // Result
            // 
            this.Result.DataPropertyName = "Result";
            this.Result.HeaderText = "Result";
            this.Result.Name = "Result";
            // 
            // ResultMessage
            // 
            this.ResultMessage.DataPropertyName = "ResultMessage";
            this.ResultMessage.HeaderText = "ResultMessage";
            this.ResultMessage.Name = "ResultMessage";
            // 
            // Postage
            // 
            this.Postage.DataPropertyName = "Postage";
            this.Postage.HeaderText = "Postage";
            this.Postage.Name = "Postage";
            // 
            // Notes
            // 
            this.Notes.DataPropertyName = "Notes";
            this.Notes.HeaderText = "Notes";
            this.Notes.Name = "Notes";
            // 
            // UserName
            // 
            this.UserName.DataPropertyName = "UserName";
            this.UserName.HeaderText = "UserName";
            this.UserName.Name = "UserName";
            this.UserName.ReadOnly = true;
            // 
            // AddressName
            // 
            this.AddressName.DataPropertyName = "AddressName";
            this.AddressName.HeaderText = "AddressName";
            this.AddressName.Name = "AddressName";
            this.AddressName.ReadOnly = true;
            // 
            // ImagesPath
            // 
            this.ImagesPath.DataPropertyName = "ImagesPath";
            this.ImagesPath.HeaderText = "ImagesPath";
            this.ImagesPath.Name = "ImagesPath";
            // 
            // BusinessLogoPath
            // 
            this.BusinessLogoPath.DataPropertyName = "BusinessLogoPath";
            this.BusinessLogoPath.HeaderText = "BusinessLogoPath";
            this.BusinessLogoPath.Name = "BusinessLogoPath";
            // 
            // WebsiteCategoryName
            // 
            this.WebsiteCategoryName.DataPropertyName = "WebsiteCategoryName";
            this.WebsiteCategoryName.HeaderText = "CategoryName";
            this.WebsiteCategoryName.Name = "WebsiteCategoryName";
            this.WebsiteCategoryName.ReadOnly = true;
            // 
            // autoPostAdPostDataBMBindingSource
            // 
            this.autoPostAdPostDataBMBindingSource.DataSource = typeof(AutoPostAdBusiness.BusinessModels.AutoPostAdPostDataBM);
            // 
            // btnSearch
            // 
            this.btnSearch.Location = new System.Drawing.Point(645, 2);
            this.btnSearch.Name = "btnSearch";
            this.btnSearch.Size = new System.Drawing.Size(75, 23);
            this.btnSearch.TabIndex = 2;
            this.btnSearch.Text = "Search";
            this.btnSearch.UseVisualStyleBackColor = true;
            this.btnSearch.Click += new System.EventHandler(this.btnSearch_Click);
            // 
            // cboSearch
            // 
            this.cboSearch.FormattingEnabled = true;
            this.cboSearch.Location = new System.Drawing.Point(266, 2);
            this.cboSearch.Name = "cboSearch";
            this.cboSearch.Size = new System.Drawing.Size(121, 21);
            this.cboSearch.TabIndex = 3;
            // 
            // txtSearch
            // 
            this.txtSearch.Location = new System.Drawing.Point(393, 2);
            this.txtSearch.Name = "txtSearch";
            this.txtSearch.Size = new System.Drawing.Size(171, 20);
            this.txtSearch.TabIndex = 4;
            // 
            // btnSaveData
            // 
            this.btnSaveData.Location = new System.Drawing.Point(1083, 376);
            this.btnSaveData.Name = "btnSaveData";
            this.btnSaveData.Size = new System.Drawing.Size(75, 23);
            this.btnSaveData.TabIndex = 5;
            this.btnSaveData.Text = "Save Data";
            this.btnSaveData.UseVisualStyleBackColor = true;
            this.btnSaveData.Click += new System.EventHandler(this.btnSaveData_Click);
            // 
            // progressBar
            // 
            this.progressBar.Location = new System.Drawing.Point(16, 34);
            this.progressBar.Name = "progressBar";
            this.progressBar.Size = new System.Drawing.Size(469, 23);
            this.progressBar.TabIndex = 6;
            // 
            // pnlProcess
            // 
            this.pnlProcess.BorderStyle = System.Windows.Forms.BorderStyle.FixedSingle;
            this.pnlProcess.Controls.Add(this.lblProcessInfo);
            this.pnlProcess.Controls.Add(this.btnContinuePost);
            this.pnlProcess.Controls.Add(this.txtVerificationCode);
            this.pnlProcess.Controls.Add(this.picVerificationCode);
            this.pnlProcess.Controls.Add(this.progressBar);
            this.pnlProcess.Location = new System.Drawing.Point(267, 126);
            this.pnlProcess.Name = "pnlProcess";
            this.pnlProcess.Size = new System.Drawing.Size(504, 149);
            this.pnlProcess.TabIndex = 7;
            this.pnlProcess.Visible = false;
            // 
            // lblProcessInfo
            // 
            this.lblProcessInfo.AutoSize = true;
            this.lblProcessInfo.Location = new System.Drawing.Point(17, 13);
            this.lblProcessInfo.Name = "lblProcessInfo";
            this.lblProcessInfo.Size = new System.Drawing.Size(35, 13);
            this.lblProcessInfo.TabIndex = 10;
            this.lblProcessInfo.Text = "label1";
            // 
            // btnContinuePost
            // 
            this.btnContinuePost.Location = new System.Drawing.Point(410, 109);
            this.btnContinuePost.Name = "btnContinuePost";
            this.btnContinuePost.Size = new System.Drawing.Size(75, 23);
            this.btnContinuePost.TabIndex = 9;
            this.btnContinuePost.Text = "Continue";
            this.btnContinuePost.UseVisualStyleBackColor = true;
            this.btnContinuePost.Visible = false;
            this.btnContinuePost.Click += new System.EventHandler(this.btnContinuePost_Click);
            // 
            // txtVerificationCode
            // 
            this.txtVerificationCode.Location = new System.Drawing.Point(262, 111);
            this.txtVerificationCode.Name = "txtVerificationCode";
            this.txtVerificationCode.Size = new System.Drawing.Size(142, 20);
            this.txtVerificationCode.TabIndex = 8;
            this.txtVerificationCode.Visible = false;
            // 
            // picVerificationCode
            // 
            this.picVerificationCode.Location = new System.Drawing.Point(16, 63);
            this.picVerificationCode.Name = "picVerificationCode";
            this.picVerificationCode.Size = new System.Drawing.Size(240, 68);
            this.picVerificationCode.TabIndex = 7;
            this.picVerificationCode.TabStop = false;
            this.picVerificationCode.Visible = false;
            // 
            // btnPostAd
            // 
            this.btnPostAd.Location = new System.Drawing.Point(1002, 376);
            this.btnPostAd.Name = "btnPostAd";
            this.btnPostAd.Size = new System.Drawing.Size(75, 23);
            this.btnPostAd.TabIndex = 8;
            this.btnPostAd.Text = "Post Ad";
            this.btnPostAd.UseVisualStyleBackColor = true;
            this.btnPostAd.Click += new System.EventHandler(this.btnPostData_Click);
            // 
            // chkSelectAll
            // 
            this.chkSelectAll.AutoSize = true;
            this.chkSelectAll.Location = new System.Drawing.Point(144, 5);
            this.chkSelectAll.Name = "chkSelectAll";
            this.chkSelectAll.Size = new System.Drawing.Size(117, 17);
            this.chkSelectAll.TabIndex = 9;
            this.chkSelectAll.Text = "Select/Deselect All";
            this.chkSelectAll.UseVisualStyleBackColor = true;
            this.chkSelectAll.CheckedChanged += new System.EventHandler(this.cboSelectAll_CheckedChanged);
            // 
            // btnDeleteAd
            // 
            this.btnDeleteAd.Location = new System.Drawing.Point(921, 376);
            this.btnDeleteAd.Name = "btnDeleteAd";
            this.btnDeleteAd.Size = new System.Drawing.Size(75, 23);
            this.btnDeleteAd.TabIndex = 10;
            this.btnDeleteAd.Text = "Delete Ad";
            this.btnDeleteAd.UseVisualStyleBackColor = true;
            this.btnDeleteAd.Click += new System.EventHandler(this.btnDeleteAd_Click);
            // 
            // chkAccurate
            // 
            this.chkAccurate.AutoSize = true;
            this.chkAccurate.Location = new System.Drawing.Point(570, 4);
            this.chkAccurate.Name = "chkAccurate";
            this.chkAccurate.Size = new System.Drawing.Size(69, 17);
            this.chkAccurate.TabIndex = 22;
            this.chkAccurate.Text = "Accurate";
            this.chkAccurate.UseVisualStyleBackColor = true;
            // 
            // cboSelect
            // 
            this.cboSelect.AutoSize = true;
            this.cboSelect.Location = new System.Drawing.Point(35, 5);
            this.cboSelect.Name = "cboSelect";
            this.cboSelect.Size = new System.Drawing.Size(103, 17);
            this.cboSelect.TabIndex = 23;
            this.cboSelect.Text = "Select/Deselect";
            this.cboSelect.UseVisualStyleBackColor = true;
            this.cboSelect.CheckedChanged += new System.EventHandler(this.cboSelect_CheckedChanged);
            // 
            // btnDAndP
            // 
            this.btnDAndP.Location = new System.Drawing.Point(841, 376);
            this.btnDAndP.Name = "btnDAndP";
            this.btnDAndP.Size = new System.Drawing.Size(74, 23);
            this.btnDAndP.TabIndex = 24;
            this.btnDAndP.Text = "Delete Post";
            this.btnDAndP.UseVisualStyleBackColor = true;
            this.btnDAndP.Click += new System.EventHandler(this.btnDAndP_Click);
            // 
            // btnGetCookie
            // 
            this.btnGetCookie.Location = new System.Drawing.Point(761, 376);
            this.btnGetCookie.Name = "btnGetCookie";
            this.btnGetCookie.Size = new System.Drawing.Size(74, 23);
            this.btnGetCookie.TabIndex = 25;
            this.btnGetCookie.Text = "Get Cookies";
            this.btnGetCookie.UseVisualStyleBackColor = true;
            this.btnGetCookie.Click += new System.EventHandler(this.btnGetCookie_Click);
            // 
            // AutoPostGumtreeAd
            // 
            this.AutoScaleDimensions = new System.Drawing.SizeF(6F, 13F);
            this.AutoScaleMode = System.Windows.Forms.AutoScaleMode.Font;
            this.ClientSize = new System.Drawing.Size(1159, 402);
            this.Controls.Add(this.btnGetCookie);
            this.Controls.Add(this.btnDAndP);
            this.Controls.Add(this.cboSelect);
            this.Controls.Add(this.chkAccurate);
            this.Controls.Add(this.btnDeleteAd);
            this.Controls.Add(this.chkSelectAll);
            this.Controls.Add(this.btnPostAd);
            this.Controls.Add(this.pnlProcess);
            this.Controls.Add(this.btnSaveData);
            this.Controls.Add(this.txtSearch);
            this.Controls.Add(this.cboSearch);
            this.Controls.Add(this.btnSearch);
            this.Controls.Add(this.dataGridView1);
            this.Name = "AutoPostGumtreeAd";
            this.Text = "Auto Post Gumtree Ad";
            this.Load += new System.EventHandler(this.AutoPostAd_Load);
            ((System.ComponentModel.ISupportInitialize)(this.dataGridView1)).EndInit();
            ((System.ComponentModel.ISupportInitialize)(this.autoPostAdPostDataBMBindingSource)).EndInit();
            ((System.ComponentModel.ISupportInitialize)(this.bindingSource1)).EndInit();
            this.pnlProcess.ResumeLayout(false);
            this.pnlProcess.PerformLayout();
            ((System.ComponentModel.ISupportInitialize)(this.picVerificationCode)).EndInit();
            this.ResumeLayout(false);
            this.PerformLayout();

        }

        #endregion

        private System.Windows.Forms.DataGridView dataGridView1;
        private System.Windows.Forms.BindingSource bindingSource1;
        private System.Windows.Forms.Button btnSearch;
        private System.Windows.Forms.ComboBox cboSearch;
        private System.Windows.Forms.TextBox txtSearch;
        private System.Windows.Forms.Button btnSaveData;
        private System.Windows.Forms.ProgressBar progressBar;
        private System.Windows.Forms.Panel pnlProcess;
        private System.Windows.Forms.PictureBox picVerificationCode;
        private System.Windows.Forms.TextBox txtVerificationCode;
        private System.Windows.Forms.Button btnContinuePost;
        private System.Windows.Forms.Label lblProcessInfo;
        private System.Windows.Forms.Button btnPostAd;
        private System.Windows.Forms.BindingSource autoPostAdPostDataBMBindingSource;
        private System.Windows.Forms.CheckBox chkSelectAll;
        private System.Windows.Forms.Button btnDeleteAd;
        private System.Windows.Forms.CheckBox chkAccurate;
        private System.Windows.Forms.CheckBox cboSelect;
        private System.Windows.Forms.Button btnDAndP;
        private System.Windows.Forms.DataGridViewCheckBoxColumn selectedDataGridViewCheckBoxColumn;
        private System.Windows.Forms.DataGridViewTextBoxColumn sKUDataGridViewTextBoxColumn;
        private System.Windows.Forms.DataGridViewTextBoxColumn priceDataGridViewTextBoxColumn;
        private System.Windows.Forms.DataGridViewTextBoxColumn titleDataGridViewTextBoxColumn;
        private System.Windows.Forms.DataGridViewTextBoxColumn descriptionDataGridViewTextBoxColumn;
        private System.Windows.Forms.DataGridViewTextBoxColumn InventoryQty;
        private System.Windows.Forms.DataGridViewTextBoxColumn LastReturnAdID;
        private System.Windows.Forms.DataGridViewTextBoxColumn Result;
        private System.Windows.Forms.DataGridViewTextBoxColumn ResultMessage;
        private System.Windows.Forms.DataGridViewTextBoxColumn Postage;
        private System.Windows.Forms.DataGridViewTextBoxColumn Notes;
        private System.Windows.Forms.DataGridViewTextBoxColumn UserName;
        private System.Windows.Forms.DataGridViewTextBoxColumn AddressName;
        private System.Windows.Forms.DataGridViewTextBoxColumn ImagesPath;
        private System.Windows.Forms.DataGridViewTextBoxColumn BusinessLogoPath;
        private System.Windows.Forms.DataGridViewTextBoxColumn WebsiteCategoryName;
        private System.Windows.Forms.Button btnGetCookie;

    }
}

