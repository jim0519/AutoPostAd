namespace AutoPostAd
{
    partial class AutoPostQuickSalesAd
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
            this.btnDeleteAd = new System.Windows.Forms.Button();
            this.chkSelectAll = new System.Windows.Forms.CheckBox();
            this.btnPostAd = new System.Windows.Forms.Button();
            this.btnSaveData = new System.Windows.Forms.Button();
            this.txtSearch = new System.Windows.Forms.TextBox();
            this.cboSearch = new System.Windows.Forms.ComboBox();
            this.btnSearch = new System.Windows.Forms.Button();
            this.dataGridView1 = new System.Windows.Forms.DataGridView();
            this.quickSalePostAdPostDataBMBindingSource = new System.Windows.Forms.BindingSource(this.components);
            this.btnReviseInfo = new System.Windows.Forms.Button();
            this.btnRelist = new System.Windows.Forms.Button();
            this.chkAccurate = new System.Windows.Forms.CheckBox();
            this.btnSelectOpposite = new System.Windows.Forms.Button();
            this.btnConvertImageLink = new System.Windows.Forms.Button();
            this.btnDownloadImages = new System.Windows.Forms.Button();
            this.cboSelect = new System.Windows.Forms.CheckBox();
            this.btnGetCategory = new System.Windows.Forms.Button();
            this.selectedDataGridViewCheckBoxColumn = new System.Windows.Forms.DataGridViewCheckBoxColumn();
            this.sKUDataGridViewTextBoxColumn = new System.Windows.Forms.DataGridViewTextBoxColumn();
            this.titleDataGridViewTextBoxColumn = new System.Windows.Forms.DataGridViewTextBoxColumn();
            this.descriptionDataGridViewTextBoxColumn = new System.Windows.Forms.DataGridViewTextBoxColumn();
            this.priceDataGridViewTextBoxColumn = new System.Windows.Forms.DataGridViewTextBoxColumn();
            this.InventoryQty = new System.Windows.Forms.DataGridViewTextBoxColumn();
            this.imagesPathDataGridViewTextBoxColumn = new System.Windows.Forms.DataGridViewTextBoxColumn();
            this.categoryDataGridViewTextBoxColumn = new System.Windows.Forms.DataGridViewTextBoxColumn();
            this.CategoryTypeID = new System.Windows.Forms.DataGridViewTextBoxColumn();
            this.quantityDataGridViewTextBoxColumn = new System.Windows.Forms.DataGridViewTextBoxColumn();
            this.Postage = new System.Windows.Forms.DataGridViewTextBoxColumn();
            this.Notes = new System.Windows.Forms.DataGridViewTextBoxColumn();
            this.LastReturnAdID = new System.Windows.Forms.DataGridViewTextBoxColumn();
            this.returnAdIDDataGridViewTextBoxColumn = new System.Windows.Forms.DataGridViewTextBoxColumn();
            this.resultDataGridViewTextBoxColumn = new System.Windows.Forms.DataGridViewTextBoxColumn();
            this.resultMessageDataGridViewTextBoxColumn = new System.Windows.Forms.DataGridViewTextBoxColumn();
            ((System.ComponentModel.ISupportInitialize)(this.dataGridView1)).BeginInit();
            ((System.ComponentModel.ISupportInitialize)(this.quickSalePostAdPostDataBMBindingSource)).BeginInit();
            this.SuspendLayout();
            // 
            // btnDeleteAd
            // 
            this.btnDeleteAd.Location = new System.Drawing.Point(772, 376);
            this.btnDeleteAd.Name = "btnDeleteAd";
            this.btnDeleteAd.Size = new System.Drawing.Size(75, 23);
            this.btnDeleteAd.TabIndex = 18;
            this.btnDeleteAd.Text = "Delete Ad";
            this.btnDeleteAd.UseVisualStyleBackColor = true;
            this.btnDeleteAd.Click += new System.EventHandler(this.btnDeleteAd_Click);
            // 
            // chkSelectAll
            // 
            this.chkSelectAll.AutoSize = true;
            this.chkSelectAll.Location = new System.Drawing.Point(142, 6);
            this.chkSelectAll.Name = "chkSelectAll";
            this.chkSelectAll.Size = new System.Drawing.Size(117, 17);
            this.chkSelectAll.TabIndex = 17;
            this.chkSelectAll.Text = "Select/Deselect All";
            this.chkSelectAll.UseVisualStyleBackColor = true;
            this.chkSelectAll.CheckedChanged += new System.EventHandler(this.chkSelectAll_CheckedChanged);
            // 
            // btnPostAd
            // 
            this.btnPostAd.Location = new System.Drawing.Point(853, 376);
            this.btnPostAd.Name = "btnPostAd";
            this.btnPostAd.Size = new System.Drawing.Size(75, 23);
            this.btnPostAd.TabIndex = 16;
            this.btnPostAd.Text = "Post Ad";
            this.btnPostAd.UseVisualStyleBackColor = true;
            this.btnPostAd.Click += new System.EventHandler(this.btnPostAd_Click);
            // 
            // btnSaveData
            // 
            this.btnSaveData.Location = new System.Drawing.Point(934, 376);
            this.btnSaveData.Name = "btnSaveData";
            this.btnSaveData.Size = new System.Drawing.Size(75, 23);
            this.btnSaveData.TabIndex = 15;
            this.btnSaveData.Text = "Save Data";
            this.btnSaveData.UseVisualStyleBackColor = true;
            this.btnSaveData.Click += new System.EventHandler(this.btnSaveData_Click);
            // 
            // txtSearch
            // 
            this.txtSearch.Location = new System.Drawing.Point(392, 4);
            this.txtSearch.Name = "txtSearch";
            this.txtSearch.Size = new System.Drawing.Size(171, 20);
            this.txtSearch.TabIndex = 14;
            // 
            // cboSearch
            // 
            this.cboSearch.FormattingEnabled = true;
            this.cboSearch.Location = new System.Drawing.Point(265, 4);
            this.cboSearch.Name = "cboSearch";
            this.cboSearch.Size = new System.Drawing.Size(121, 21);
            this.cboSearch.TabIndex = 13;
            // 
            // btnSearch
            // 
            this.btnSearch.Location = new System.Drawing.Point(644, 2);
            this.btnSearch.Name = "btnSearch";
            this.btnSearch.Size = new System.Drawing.Size(75, 23);
            this.btnSearch.TabIndex = 12;
            this.btnSearch.Text = "Search";
            this.btnSearch.UseVisualStyleBackColor = true;
            this.btnSearch.Click += new System.EventHandler(this.btnSearch_Click);
            // 
            // dataGridView1
            // 
            this.dataGridView1.AllowUserToOrderColumns = true;
            this.dataGridView1.AutoGenerateColumns = false;
            this.dataGridView1.ColumnHeadersHeightSizeMode = System.Windows.Forms.DataGridViewColumnHeadersHeightSizeMode.AutoSize;
            this.dataGridView1.Columns.AddRange(new System.Windows.Forms.DataGridViewColumn[] {
            this.selectedDataGridViewCheckBoxColumn,
            this.sKUDataGridViewTextBoxColumn,
            this.titleDataGridViewTextBoxColumn,
            this.descriptionDataGridViewTextBoxColumn,
            this.priceDataGridViewTextBoxColumn,
            this.InventoryQty,
            this.imagesPathDataGridViewTextBoxColumn,
            this.categoryDataGridViewTextBoxColumn,
            this.CategoryTypeID,
            this.quantityDataGridViewTextBoxColumn,
            this.Postage,
            this.Notes,
            this.LastReturnAdID,
            this.returnAdIDDataGridViewTextBoxColumn,
            this.resultDataGridViewTextBoxColumn,
            this.resultMessageDataGridViewTextBoxColumn});
            this.dataGridView1.DataSource = this.quickSalePostAdPostDataBMBindingSource;
            this.dataGridView1.Location = new System.Drawing.Point(4, 28);
            this.dataGridView1.Name = "dataGridView1";
            this.dataGridView1.Size = new System.Drawing.Size(1016, 342);
            this.dataGridView1.TabIndex = 11;
            // 
            // quickSalePostAdPostDataBMBindingSource
            // 
            this.quickSalePostAdPostDataBMBindingSource.DataSource = typeof(AutoPostAdBusiness.BusinessModels.QuickSalePostAdPostDataBM);
            // 
            // btnReviseInfo
            // 
            this.btnReviseInfo.Location = new System.Drawing.Point(691, 376);
            this.btnReviseInfo.Name = "btnReviseInfo";
            this.btnReviseInfo.Size = new System.Drawing.Size(75, 23);
            this.btnReviseInfo.TabIndex = 19;
            this.btnReviseInfo.Text = "Revise Info";
            this.btnReviseInfo.UseVisualStyleBackColor = true;
            this.btnReviseInfo.Click += new System.EventHandler(this.btnReviseInfo_Click);
            // 
            // btnRelist
            // 
            this.btnRelist.Location = new System.Drawing.Point(610, 376);
            this.btnRelist.Name = "btnRelist";
            this.btnRelist.Size = new System.Drawing.Size(75, 23);
            this.btnRelist.TabIndex = 20;
            this.btnRelist.Text = "Relist Ad";
            this.btnRelist.UseVisualStyleBackColor = true;
            this.btnRelist.Click += new System.EventHandler(this.btnRelist_Click);
            // 
            // chkAccurate
            // 
            this.chkAccurate.AutoSize = true;
            this.chkAccurate.Location = new System.Drawing.Point(569, 7);
            this.chkAccurate.Name = "chkAccurate";
            this.chkAccurate.Size = new System.Drawing.Size(69, 17);
            this.chkAccurate.TabIndex = 21;
            this.chkAccurate.Text = "Accurate";
            this.chkAccurate.UseVisualStyleBackColor = true;
            // 
            // btnSelectOpposite
            // 
            this.btnSelectOpposite.Location = new System.Drawing.Point(725, 2);
            this.btnSelectOpposite.Name = "btnSelectOpposite";
            this.btnSelectOpposite.Size = new System.Drawing.Size(98, 23);
            this.btnSelectOpposite.TabIndex = 22;
            this.btnSelectOpposite.Text = "Select Opposite";
            this.btnSelectOpposite.UseVisualStyleBackColor = true;
            this.btnSelectOpposite.Click += new System.EventHandler(this.btnSelectOpposite_Click);
            // 
            // btnConvertImageLink
            // 
            this.btnConvertImageLink.Location = new System.Drawing.Point(496, 376);
            this.btnConvertImageLink.Name = "btnConvertImageLink";
            this.btnConvertImageLink.Size = new System.Drawing.Size(108, 23);
            this.btnConvertImageLink.TabIndex = 23;
            this.btnConvertImageLink.Text = "Convert Image Link";
            this.btnConvertImageLink.UseVisualStyleBackColor = true;
            this.btnConvertImageLink.Click += new System.EventHandler(this.btnConvertImageLink_Click);
            // 
            // btnDownloadImages
            // 
            this.btnDownloadImages.Location = new System.Drawing.Point(390, 376);
            this.btnDownloadImages.Name = "btnDownloadImages";
            this.btnDownloadImages.Size = new System.Drawing.Size(100, 23);
            this.btnDownloadImages.TabIndex = 24;
            this.btnDownloadImages.Text = "Download Images";
            this.btnDownloadImages.UseVisualStyleBackColor = true;
            this.btnDownloadImages.Click += new System.EventHandler(this.btnDownloadImages_Click);
            // 
            // cboSelect
            // 
            this.cboSelect.AutoSize = true;
            this.cboSelect.Location = new System.Drawing.Point(33, 5);
            this.cboSelect.Name = "cboSelect";
            this.cboSelect.Size = new System.Drawing.Size(103, 17);
            this.cboSelect.TabIndex = 25;
            this.cboSelect.Text = "Select/Deselect";
            this.cboSelect.UseVisualStyleBackColor = true;
            this.cboSelect.CheckedChanged += new System.EventHandler(this.cboSelect_CheckedChanged);
            // 
            // btnGetCategory
            // 
            this.btnGetCategory.Location = new System.Drawing.Point(286, 376);
            this.btnGetCategory.Name = "btnGetCategory";
            this.btnGetCategory.Size = new System.Drawing.Size(100, 23);
            this.btnGetCategory.TabIndex = 26;
            this.btnGetCategory.Text = "Get Category";
            this.btnGetCategory.UseVisualStyleBackColor = true;
            this.btnGetCategory.Click += new System.EventHandler(this.btnGetCategory_Click);
            // 
            // selectedDataGridViewCheckBoxColumn
            // 
            this.selectedDataGridViewCheckBoxColumn.DataPropertyName = "Selected";
            this.selectedDataGridViewCheckBoxColumn.HeaderText = "Selected";
            this.selectedDataGridViewCheckBoxColumn.Name = "selectedDataGridViewCheckBoxColumn";
            // 
            // sKUDataGridViewTextBoxColumn
            // 
            this.sKUDataGridViewTextBoxColumn.DataPropertyName = "SKU";
            this.sKUDataGridViewTextBoxColumn.HeaderText = "SKU";
            this.sKUDataGridViewTextBoxColumn.Name = "sKUDataGridViewTextBoxColumn";
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
            // priceDataGridViewTextBoxColumn
            // 
            this.priceDataGridViewTextBoxColumn.DataPropertyName = "Price";
            this.priceDataGridViewTextBoxColumn.HeaderText = "Price";
            this.priceDataGridViewTextBoxColumn.Name = "priceDataGridViewTextBoxColumn";
            // 
            // InventoryQty
            // 
            this.InventoryQty.DataPropertyName = "InventoryQty";
            this.InventoryQty.HeaderText = "InventoryQty";
            this.InventoryQty.Name = "InventoryQty";
            // 
            // imagesPathDataGridViewTextBoxColumn
            // 
            this.imagesPathDataGridViewTextBoxColumn.DataPropertyName = "ImagesPath";
            this.imagesPathDataGridViewTextBoxColumn.HeaderText = "ImagesPath";
            this.imagesPathDataGridViewTextBoxColumn.Name = "imagesPathDataGridViewTextBoxColumn";
            // 
            // categoryDataGridViewTextBoxColumn
            // 
            this.categoryDataGridViewTextBoxColumn.DataPropertyName = "Category";
            this.categoryDataGridViewTextBoxColumn.HeaderText = "Category";
            this.categoryDataGridViewTextBoxColumn.Name = "categoryDataGridViewTextBoxColumn";
            this.categoryDataGridViewTextBoxColumn.ReadOnly = true;
            // 
            // CategoryTypeID
            // 
            this.CategoryTypeID.DataPropertyName = "CategoryTypeID";
            this.CategoryTypeID.HeaderText = "CategoryTypeID";
            this.CategoryTypeID.Name = "CategoryTypeID";
            this.CategoryTypeID.ReadOnly = true;
            // 
            // quantityDataGridViewTextBoxColumn
            // 
            this.quantityDataGridViewTextBoxColumn.DataPropertyName = "Quantity";
            this.quantityDataGridViewTextBoxColumn.HeaderText = "Quantity";
            this.quantityDataGridViewTextBoxColumn.Name = "quantityDataGridViewTextBoxColumn";
            this.quantityDataGridViewTextBoxColumn.ReadOnly = true;
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
            // LastReturnAdID
            // 
            this.LastReturnAdID.DataPropertyName = "LastReturnAdID";
            this.LastReturnAdID.HeaderText = "LastReturnAdID";
            this.LastReturnAdID.Name = "LastReturnAdID";
            this.LastReturnAdID.ReadOnly = true;
            // 
            // returnAdIDDataGridViewTextBoxColumn
            // 
            this.returnAdIDDataGridViewTextBoxColumn.DataPropertyName = "ReturnAdID";
            this.returnAdIDDataGridViewTextBoxColumn.HeaderText = "ReturnAdID";
            this.returnAdIDDataGridViewTextBoxColumn.Name = "returnAdIDDataGridViewTextBoxColumn";
            // 
            // resultDataGridViewTextBoxColumn
            // 
            this.resultDataGridViewTextBoxColumn.DataPropertyName = "Result";
            this.resultDataGridViewTextBoxColumn.HeaderText = "Result";
            this.resultDataGridViewTextBoxColumn.Name = "resultDataGridViewTextBoxColumn";
            // 
            // resultMessageDataGridViewTextBoxColumn
            // 
            this.resultMessageDataGridViewTextBoxColumn.DataPropertyName = "ResultMessage";
            this.resultMessageDataGridViewTextBoxColumn.HeaderText = "ResultMessage";
            this.resultMessageDataGridViewTextBoxColumn.Name = "resultMessageDataGridViewTextBoxColumn";
            // 
            // AutoPostQuickSalesAd
            // 
            this.AutoScaleDimensions = new System.Drawing.SizeF(6F, 13F);
            this.AutoScaleMode = System.Windows.Forms.AutoScaleMode.Font;
            this.ClientSize = new System.Drawing.Size(1021, 408);
            this.Controls.Add(this.btnGetCategory);
            this.Controls.Add(this.cboSelect);
            this.Controls.Add(this.btnDownloadImages);
            this.Controls.Add(this.btnConvertImageLink);
            this.Controls.Add(this.btnSelectOpposite);
            this.Controls.Add(this.chkAccurate);
            this.Controls.Add(this.btnRelist);
            this.Controls.Add(this.btnReviseInfo);
            this.Controls.Add(this.btnDeleteAd);
            this.Controls.Add(this.chkSelectAll);
            this.Controls.Add(this.btnPostAd);
            this.Controls.Add(this.btnSaveData);
            this.Controls.Add(this.txtSearch);
            this.Controls.Add(this.cboSearch);
            this.Controls.Add(this.btnSearch);
            this.Controls.Add(this.dataGridView1);
            this.Name = "AutoPostQuickSalesAd";
            this.Text = "AutoPostQuickSalesAd";
            this.Load += new System.EventHandler(this.AutoPostQuickSalesAd_Load);
            ((System.ComponentModel.ISupportInitialize)(this.dataGridView1)).EndInit();
            ((System.ComponentModel.ISupportInitialize)(this.quickSalePostAdPostDataBMBindingSource)).EndInit();
            this.ResumeLayout(false);
            this.PerformLayout();

        }

        #endregion

        private System.Windows.Forms.Button btnDeleteAd;
        private System.Windows.Forms.CheckBox chkSelectAll;
        private System.Windows.Forms.Button btnPostAd;
        private System.Windows.Forms.Button btnSaveData;
        private System.Windows.Forms.TextBox txtSearch;
        private System.Windows.Forms.ComboBox cboSearch;
        private System.Windows.Forms.Button btnSearch;
        private System.Windows.Forms.DataGridView dataGridView1;
        private System.Windows.Forms.BindingSource quickSalePostAdPostDataBMBindingSource;
        private System.Windows.Forms.Button btnReviseInfo;
        private System.Windows.Forms.Button btnRelist;
        private System.Windows.Forms.CheckBox chkAccurate;
        private System.Windows.Forms.Button btnSelectOpposite;
        private System.Windows.Forms.Button btnConvertImageLink;
        private System.Windows.Forms.Button btnDownloadImages;
        private System.Windows.Forms.CheckBox cboSelect;
        private System.Windows.Forms.Button btnGetCategory;
        private System.Windows.Forms.DataGridViewCheckBoxColumn selectedDataGridViewCheckBoxColumn;
        private System.Windows.Forms.DataGridViewTextBoxColumn sKUDataGridViewTextBoxColumn;
        private System.Windows.Forms.DataGridViewTextBoxColumn titleDataGridViewTextBoxColumn;
        private System.Windows.Forms.DataGridViewTextBoxColumn descriptionDataGridViewTextBoxColumn;
        private System.Windows.Forms.DataGridViewTextBoxColumn priceDataGridViewTextBoxColumn;
        private System.Windows.Forms.DataGridViewTextBoxColumn InventoryQty;
        private System.Windows.Forms.DataGridViewTextBoxColumn imagesPathDataGridViewTextBoxColumn;
        private System.Windows.Forms.DataGridViewTextBoxColumn categoryDataGridViewTextBoxColumn;
        private System.Windows.Forms.DataGridViewTextBoxColumn CategoryTypeID;
        private System.Windows.Forms.DataGridViewTextBoxColumn quantityDataGridViewTextBoxColumn;
        private System.Windows.Forms.DataGridViewTextBoxColumn Postage;
        private System.Windows.Forms.DataGridViewTextBoxColumn Notes;
        private System.Windows.Forms.DataGridViewTextBoxColumn LastReturnAdID;
        private System.Windows.Forms.DataGridViewTextBoxColumn returnAdIDDataGridViewTextBoxColumn;
        private System.Windows.Forms.DataGridViewTextBoxColumn resultDataGridViewTextBoxColumn;
        private System.Windows.Forms.DataGridViewTextBoxColumn resultMessageDataGridViewTextBoxColumn;
    }
}