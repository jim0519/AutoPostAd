namespace AutoPostAd
{
    partial class MainForm
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
            this.msMenu = new System.Windows.Forms.MenuStrip();
            this.gumtreeAdToolStripMenuItem = new System.Windows.Forms.ToolStripMenuItem();
            this.quickSaleAdToolStripMenuItem = new System.Windows.Forms.ToolStripMenuItem();
            this.eBayToolStripMenuItem = new System.Windows.Forms.ToolStripMenuItem();
            this.msMenu.SuspendLayout();
            this.SuspendLayout();
            // 
            // msMenu
            // 
            this.msMenu.Items.AddRange(new System.Windows.Forms.ToolStripItem[] {
            this.gumtreeAdToolStripMenuItem,
            this.quickSaleAdToolStripMenuItem,
            this.eBayToolStripMenuItem});
            this.msMenu.Location = new System.Drawing.Point(0, 0);
            this.msMenu.Name = "msMenu";
            this.msMenu.Size = new System.Drawing.Size(1086, 24);
            this.msMenu.TabIndex = 1;
            this.msMenu.Text = "menuStrip1";
            // 
            // gumtreeAdToolStripMenuItem
            // 
            this.gumtreeAdToolStripMenuItem.Name = "gumtreeAdToolStripMenuItem";
            this.gumtreeAdToolStripMenuItem.Size = new System.Drawing.Size(80, 20);
            this.gumtreeAdToolStripMenuItem.Text = "GumtreeAd";
            this.gumtreeAdToolStripMenuItem.Click += new System.EventHandler(this.gumtreeAdToolStripMenuItem_Click);
            // 
            // quickSaleAdToolStripMenuItem
            // 
            this.quickSaleAdToolStripMenuItem.Name = "quickSaleAdToolStripMenuItem";
            this.quickSaleAdToolStripMenuItem.Size = new System.Drawing.Size(86, 20);
            this.quickSaleAdToolStripMenuItem.Text = "QuickSaleAd";
            this.quickSaleAdToolStripMenuItem.Click += new System.EventHandler(this.quickSaleAdToolStripMenuItem_Click);
            // 
            // eBayToolStripMenuItem
            // 
            this.eBayToolStripMenuItem.Name = "eBayToolStripMenuItem";
            this.eBayToolStripMenuItem.Size = new System.Drawing.Size(44, 20);
            this.eBayToolStripMenuItem.Text = "eBay";
            // 
            // MainForm
            // 
            this.AutoScaleDimensions = new System.Drawing.SizeF(6F, 13F);
            this.AutoScaleMode = System.Windows.Forms.AutoScaleMode.Font;
            this.ClientSize = new System.Drawing.Size(1086, 498);
            this.Controls.Add(this.msMenu);
            this.IsMdiContainer = true;
            this.MainMenuStrip = this.msMenu;
            this.Name = "MainForm";
            this.Text = "MainForm";
            this.Load += new System.EventHandler(this.MainForm_Load);
            this.msMenu.ResumeLayout(false);
            this.msMenu.PerformLayout();
            this.ResumeLayout(false);
            this.PerformLayout();

        }

        #endregion

        private System.Windows.Forms.MenuStrip msMenu;
        private System.Windows.Forms.ToolStripMenuItem gumtreeAdToolStripMenuItem;
        private System.Windows.Forms.ToolStripMenuItem quickSaleAdToolStripMenuItem;
        private System.Windows.Forms.ToolStripMenuItem eBayToolStripMenuItem;
    }
}