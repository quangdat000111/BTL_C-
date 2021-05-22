using Data;
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
    public partial class TrangChu_Form : Form
    {
        private string MaGV;
        public TrangChu_Form()
        {
            InitializeComponent();
        }

        public TrangChu_Form(String ID)
        {
            MaGV = ID;
            InitializeComponent();
        }

        private void TrangChu_Form_Load(object sender, EventArgs e)
        {
            DataTable dt = new Database().SelectData("EXEC TenMonHoc_GiangVienDay '" + MaGV + "'");
            if (dt != null)
            {
                for (int i = 0; i < dt.Rows.Count; i++)
                {
                    comboBox1.Items.Add(dt.Rows[i][0].ToString());
                }
                comboBox1.SelectedIndex = 0;
                thongKe(comboBox1.Text);
            }
        }

        public void thongKe(String TenMH)
        {
            dataGridView1.DataSource = new Database().SelectData("SELECT * FROM Fn_ThongKe (N'" + TenMH + "')");
            if (dataGridView1.DataSource != null)
            {
                dataGridView1.Columns[0].HeaderText = "Mã lớp";
                dataGridView1.Columns[1].HeaderText = "Số lượng sinh viên";
                dataGridView1.Columns[2].HeaderText = "0 - 3.9 (F)";
                dataGridView1.Columns[3].HeaderText = "4 - 4.6 (D)";
                dataGridView1.Columns[4].HeaderText = "4.6 - 5.4 (D+)";
                dataGridView1.Columns[5].HeaderText = "5.5 - 6.1 (C)";
                dataGridView1.Columns[6].HeaderText = "6.2 - 6.9 (C+)";
                dataGridView1.Columns[7].HeaderText = "7 - 7.6 (B)";
                dataGridView1.Columns[8].HeaderText = "7.7 - 8.4 (B+)";
                dataGridView1.Columns[9].HeaderText = "8.5 - 10 (A)";
            }
        }

        private void comboBox1_SelectedIndexChanged(object sender, EventArgs e)
        {
            thongKe(comboBox1.Text);
        }

        private void comboBox2_SelectedIndexChanged(object sender, EventArgs e)
        {
            if(comboBox2.SelectedIndex != -1)
            {
                sapXep(comboBox2.SelectedIndex);
            }    
        }

        private void radioButton1_CheckedChanged(object sender, EventArgs e)
        {
            if (comboBox2.SelectedIndex != -1)
            {
                sapXep(comboBox2.SelectedIndex);
            }
        }

        private void radioButton2_CheckedChanged(object sender, EventArgs e)
        {
            if (comboBox2.SelectedIndex != -1)
            {
                sapXep(comboBox2.SelectedIndex);
            }
        }

        private void sapXep(int index)
        {
            if (radioButton1.Checked)
                dataGridView1.Sort(dataGridView1.Columns[index], ListSortDirection.Ascending);
            else
                dataGridView1.Sort(dataGridView1.Columns[index], ListSortDirection.Descending);
        }
    }
}
