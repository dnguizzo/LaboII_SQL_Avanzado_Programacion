using System;
using System.Collections.Generic;
using System.ComponentModel;
using System.Data;
using System.Drawing;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Windows.Forms;

namespace ConsultasAutomotriz
{
    public partial class frmConsultas : Form
    {
        private Helper helper = new Helper();
        public frmConsultas()
        {
            InitializeComponent();

        }

        private void frmConsultas_Load(object sender, EventArgs e)
        {
            cboIntegrante.SelectedValue = -1;
            cboIntegrante.DropDownStyle = ComboBoxStyle.DropDownList;
            rbC1.Checked = true;
        }

        private void btnConsultar_Click(object sender, EventArgs e)
        {
            
            dgvResultados.Rows.Clear();
            if (cboIntegrante.Text == "Conrado-Vitelli" && rbC1.Checked == true)
            {
                dgvResultados.DataSource = helper.Consultar("SP_VITELLI_1");
                //MessageBox.Show("ok1");
            }
            if (cboIntegrante.Text == "Conrado-Vitelli" && rbC2.Checked == true)
            {
                dgvResultados.DataSource = helper.Consultar("SP_VITELLI_2");
                //MessageBox.Show("ok2");
            }
            ///////////////////////////////////////////////////////////////////////////////////////////
            if (cboIntegrante.Text == "Diego-Nicolas-Guizzo" && rbC1.Checked == true)
            {
                Enunciado.DataSource = helper.Consultar("CONSULTA_GUIZZO_1");
                dgvResultados.DataSource = helper.Consultar("SP_GUIZZO_1");
                //MessageBox.Show("ok1");
            }
            if (cboIntegrante.Text == "Diego-Nicolas-Guizzo" && rbC2.Checked == true)
            {
                dgvResultados.DataSource = helper.Consultar("SP_GUIZZO_2");
                //MessageBox.Show("ok2");
            }
            ///////////////////////////////////////////////////////////////////////////////////////////
            if (cboIntegrante.Text == "Federico-Ahumada" && rbC1.Checked == true)
            {
                dgvResultados.DataSource = helper.Consultar("");
                //MessageBox.Show("ok1");
            }
            if (cboIntegrante.Text == "Federico-Ahumada" && rbC2.Checked == true)
            {
                dgvResultados.DataSource = helper.Consultar("");
                //MessageBox.Show("ok2");
            }
            ///////////////////////////////////////////////////////////////////////////////////////////
            if (cboIntegrante.Text == "Matias-Nicolas-Villarruel" && rbC1.Checked == true)
            {
                dgvResultados.DataSource = helper.Consultar("SP_VILLARRUEL_1");
                //MessageBox.Show("ok1");
            }
            if (cboIntegrante.Text == "Matias-Nicolas-Villarruel" && rbC2.Checked == true)
            {
                //dgvResultados.DataSource = helper.Consultar("");
                MessageBox.Show("ok2");
            }
        }
    }
}
