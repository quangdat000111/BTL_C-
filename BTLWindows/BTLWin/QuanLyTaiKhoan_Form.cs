using System;
using System.Collections.Generic;
using System.ComponentModel;
using System.Data;
using System.Drawing;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Windows.Forms;

namespace BTLWin
{
    public partial class QuanLyTaiKhoan_Form : Form
    {
        private String username, password;
        public QuanLyTaiKhoan_Form()
        {
            InitializeComponent();
        }
        public void NapDuLieu_Datagridview1()
        {
            dataGridView1.Rows[0].Cells[0].Value = 1;
            dataGridView1.Rows[1].Cells[0].Value = 2;
            dataGridView1.Rows[2].Cells[0].Value = 3;
            dataGridView1.Rows[0].Cells[1].Value = "Giảng viên";
            dataGridView1.Rows[1].Cells[1].Value = "Sinh viên";
            dataGridView1.Rows[2].Cells[1].Value = "Quản trị viên";

        }
        private void QuanLyTaiKhoan_Form_Load(object sender, EventArgs e)
        {

        }
    }
}
