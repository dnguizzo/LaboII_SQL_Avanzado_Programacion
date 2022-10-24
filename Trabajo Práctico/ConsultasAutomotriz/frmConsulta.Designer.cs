namespace ConsultasAutomotriz
{
    partial class frmConsultas
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
            System.ComponentModel.ComponentResourceManager resources = new System.ComponentModel.ComponentResourceManager(typeof(frmConsultas));
            this.groupBox2 = new System.Windows.Forms.GroupBox();
            this.dgvResultados = new System.Windows.Forms.DataGridView();
            this.groupBox1 = new System.Windows.Forms.GroupBox();
            this.rbC2 = new System.Windows.Forms.RadioButton();
            this.rbC1 = new System.Windows.Forms.RadioButton();
            this.btnConsultar = new System.Windows.Forms.Button();
            this.label1 = new System.Windows.Forms.Label();
            this.cboIntegrante = new System.Windows.Forms.ComboBox();
            this.lstEnunciado = new System.Windows.Forms.ListBox();
            this.groupBox2.SuspendLayout();
            ((System.ComponentModel.ISupportInitialize)(this.dgvResultados)).BeginInit();
            this.groupBox1.SuspendLayout();
            this.SuspendLayout();
            // 
            // groupBox2
            // 
            this.groupBox2.Controls.Add(this.dgvResultados);
            this.groupBox2.Location = new System.Drawing.Point(12, 144);
            this.groupBox2.Name = "groupBox2";
            this.groupBox2.Size = new System.Drawing.Size(817, 215);
            this.groupBox2.TabIndex = 3;
            this.groupBox2.TabStop = false;
            this.groupBox2.Text = "Resultados:";
            // 
            // dgvResultados
            // 
            this.dgvResultados.AllowUserToAddRows = false;
            this.dgvResultados.AllowUserToDeleteRows = false;
            this.dgvResultados.ColumnHeadersHeightSizeMode = System.Windows.Forms.DataGridViewColumnHeadersHeightSizeMode.AutoSize;
            this.dgvResultados.Location = new System.Drawing.Point(6, 17);
            this.dgvResultados.Name = "dgvResultados";
            this.dgvResultados.ReadOnly = true;
            this.dgvResultados.Size = new System.Drawing.Size(805, 190);
            this.dgvResultados.TabIndex = 0;
            // 
            // groupBox1
            // 
            this.groupBox1.Controls.Add(this.rbC2);
            this.groupBox1.Controls.Add(this.rbC1);
            this.groupBox1.Controls.Add(this.btnConsultar);
            this.groupBox1.Controls.Add(this.label1);
            this.groupBox1.Controls.Add(this.cboIntegrante);
            this.groupBox1.Location = new System.Drawing.Point(12, 12);
            this.groupBox1.Name = "groupBox1";
            this.groupBox1.Size = new System.Drawing.Size(402, 126);
            this.groupBox1.TabIndex = 2;
            this.groupBox1.TabStop = false;
            this.groupBox1.Text = "Filtros:";
            // 
            // rbC2
            // 
            this.rbC2.AutoSize = true;
            this.rbC2.Location = new System.Drawing.Point(177, 81);
            this.rbC2.Name = "rbC2";
            this.rbC2.Size = new System.Drawing.Size(75, 17);
            this.rbC2.TabIndex = 6;
            this.rbC2.TabStop = true;
            this.rbC2.Text = "Consulta 2";
            this.rbC2.UseVisualStyleBackColor = true;
            // 
            // rbC1
            // 
            this.rbC1.AutoSize = true;
            this.rbC1.Location = new System.Drawing.Point(64, 81);
            this.rbC1.Name = "rbC1";
            this.rbC1.Size = new System.Drawing.Size(75, 17);
            this.rbC1.TabIndex = 5;
            this.rbC1.TabStop = true;
            this.rbC1.Text = "Consulta 1";
            this.rbC1.UseVisualStyleBackColor = true;
            // 
            // btnConsultar
            // 
            this.btnConsultar.Location = new System.Drawing.Point(279, 37);
            this.btnConsultar.Name = "btnConsultar";
            this.btnConsultar.Size = new System.Drawing.Size(111, 23);
            this.btnConsultar.TabIndex = 4;
            this.btnConsultar.Text = "Consultar";
            this.btnConsultar.UseVisualStyleBackColor = true;
            this.btnConsultar.Click += new System.EventHandler(this.btnConsultar_Click);
            // 
            // label1
            // 
            this.label1.AutoSize = true;
            this.label1.Location = new System.Drawing.Point(19, 41);
            this.label1.Name = "label1";
            this.label1.Size = new System.Drawing.Size(58, 13);
            this.label1.TabIndex = 1;
            this.label1.Text = "Integrante:";
            // 
            // cboIntegrante
            // 
            this.cboIntegrante.FormattingEnabled = true;
            this.cboIntegrante.Items.AddRange(new object[] {
            "Conrado-Vitelli",
            "Diego-Nicolas-Guizzo",
            "Federico-Ahumada",
            "Matias-Nicolas-Villarruel"});
            this.cboIntegrante.Location = new System.Drawing.Point(83, 38);
            this.cboIntegrante.Name = "cboIntegrante";
            this.cboIntegrante.Size = new System.Drawing.Size(166, 21);
            this.cboIntegrante.TabIndex = 0;
            // 
            // lstEnunciado
            // 
            this.lstEnunciado.FormattingEnabled = true;
            this.lstEnunciado.HorizontalScrollbar = true;
            this.lstEnunciado.Location = new System.Drawing.Point(420, 17);
            this.lstEnunciado.Name = "lstEnunciado";
            this.lstEnunciado.Size = new System.Drawing.Size(403, 121);
            this.lstEnunciado.TabIndex = 4;
            // 
            // frmConsultas
            // 
            this.AutoScaleDimensions = new System.Drawing.SizeF(6F, 13F);
            this.AutoScaleMode = System.Windows.Forms.AutoScaleMode.Font;
            this.ClientSize = new System.Drawing.Size(841, 371);
            this.Controls.Add(this.lstEnunciado);
            this.Controls.Add(this.groupBox2);
            this.Controls.Add(this.groupBox1);
            this.Icon = ((System.Drawing.Icon)(resources.GetObject("$this.Icon")));
            this.MinimumSize = new System.Drawing.Size(518, 374);
            this.Name = "frmConsultas";
            this.StartPosition = System.Windows.Forms.FormStartPosition.CenterScreen;
            this.Text = "CONSULTAS AUTOMOTRIZ";
            this.Load += new System.EventHandler(this.frmConsultas_Load);
            this.groupBox2.ResumeLayout(false);
            ((System.ComponentModel.ISupportInitialize)(this.dgvResultados)).EndInit();
            this.groupBox1.ResumeLayout(false);
            this.groupBox1.PerformLayout();
            this.ResumeLayout(false);

        }

        #endregion

        private System.Windows.Forms.GroupBox groupBox2;
        private System.Windows.Forms.DataGridView dgvResultados;
        private System.Windows.Forms.GroupBox groupBox1;
        private System.Windows.Forms.Button btnConsultar;
        private System.Windows.Forms.Label label1;
        private System.Windows.Forms.ComboBox cboIntegrante;
        private System.Windows.Forms.RadioButton rbC2;
        private System.Windows.Forms.RadioButton rbC1;
        private System.Windows.Forms.ListBox lstEnunciado;
    }
}

