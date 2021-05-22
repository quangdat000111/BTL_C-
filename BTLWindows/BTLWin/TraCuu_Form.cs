using System;
using System.Collections.Generic;
using System.ComponentModel;
using System.Data;
using System.Drawing;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Windows.Forms;
using Data;

namespace BTLWin
{
    public partial class TraCuu_Form : Form
    {
        public int btnTag { set; get; }

        public TraCuu_Form()
        {
            InitializeComponent();
            btnHuyKQ.Visible = false;
        }

        public TraCuu_Form(int tag)
        {
            InitializeComponent();
            btnHuyKQ.Visible = false;
            btnTag = tag;
        }

        private void btnHuyKQ_Click(object sender, EventArgs e)
        {
            layDuLieu();
        }

        private void layDuLieu()
        {
            string query;
            switch (btnTag)
            {
                case 1:
                    query = "SELECT * FROM MONHOC";
                    layDanhSachMonHoc(query);
                    break;
                case 2:
                    query = "SELECT * FROM LOP";
                    layDanhSachLop(query);
                    break;
                case 3:
                    query = "SELECT * FROM GIANGVIEN";
                    layDanhSachGiangVien(query);
                    break;
                case 4:
                    query = "SELECT * FROM LOP_MONHOC";
                    layDanhSachLopTheoMon(query);
                    break;
                case 5:
                    query = "SELECT * FROM SINHVIEN";
                    layDanhSachSinhVien(query);
                    break;
            }
            btnHuyKQ.Visible = false;
        }

        public void layDanhSachLop(string query)
        {
            lblTimKiem.Text = "Tìm kiếm theo mã lớp";
            dataGridView1.DataSource = new Database().SelectData(query);
            if (dataGridView1.DataSource != null)
            {
                dataGridView1.Columns[0].HeaderText = "Mã lớp";
                dataGridView1.Columns[1].HeaderText = "Tên lớp";
                dataGridView1.Columns[2].HeaderText = "Tên khoa";
                dataGridView1.Columns[3].HeaderText = "Giáo viên chủ nhiệm";
                dataGridView1.Columns[4].HeaderText = "Số lượng sinh viên";
            }
        }

        public void layDanhSachMonHoc(string query)
        {
            lblTimKiem.Text = "Tìm kiếm theo mã môn";
            dataGridView1.DataSource = new Database().SelectData(query);
            if (dataGridView1.DataSource != null)
            {
                dataGridView1.Columns[0].HeaderText = "Mã môn học";
                dataGridView1.Columns[1].HeaderText = "Tên môn học";
                dataGridView1.Columns[2].HeaderText = "Số tín chỉ";
            }
        }

        public void layDanhSachGiangVien(string query)
        {
            lblTimKiem.Text = "Tìm kiếm theo mã giảng viên";
            dataGridView1.DataSource = new Database().SelectData(query);
            if (dataGridView1.DataSource != null)
            {
                dataGridView1.Columns[0].HeaderText = "Mã giảng viên";
                dataGridView1.Columns[1].HeaderText = "Tên giảng viên";
                dataGridView1.Columns[2].HeaderText = "Ngày sinh";
                dataGridView1.Columns[3].HeaderText = "Giới tính";
                dataGridView1.Columns[4].HeaderText = "Địa chỉ";
                dataGridView1.Columns[5].HeaderText = "Số điện thoại";
            }
        }

        public void layDanhSachLopTheoMon(string query)
        {
            lblTimKiem.Text = "Tìm kiếm theo mã lớp";
            dataGridView1.DataSource = new Database().SelectData(query);
            if (dataGridView1.DataSource != null)
            {
                dataGridView1.Columns[0].HeaderText = "Mã lớp";
                dataGridView1.Columns[1].HeaderText = "Mã môn học";
                dataGridView1.Columns[2].HeaderText = "Mã giảng viên";
                dataGridView1.Columns[3].HeaderText = "Phòng học";
                dataGridView1.Columns[4].HeaderText = "Thời gian";
                dataGridView1.Columns[5].HeaderText = "Bắt đầu";
                dataGridView1.Columns[6].HeaderText = "Kết thúc";
            }
        }

        public void layDanhSachSinhVien(string query)
        {
            lblTimKiem.Text = "Tìm kiếm theo mã sinh viên";
            dataGridView1.DataSource = new Database().SelectData(query);
            if (dataGridView1.DataSource != null)
            {
                dataGridView1.Columns[0].HeaderText = "Mã lớp";
                dataGridView1.Columns[1].HeaderText = "Mã sinh viên";
                dataGridView1.Columns[2].HeaderText = "Họ tên sinh viên";
                dataGridView1.Columns[3].HeaderText = "Ngày sinh";
                dataGridView1.Columns[4].HeaderText = "Giới tính";
                dataGridView1.Columns[5].HeaderText = "Địa chỉ";
                dataGridView1.Columns[6].HeaderText = "Số điện thoại";
            }
        }

        private void btnTimKiem_Click(object sender, EventArgs e)
        {
            if (textBox1.Text != "")
            {
                string search = textBox1.Text.ToString().Trim();
                string query;
                switch (btnTag)
                {
                    case 1:
                        query = "EXEC TimKiem_Mon '" + search + "'";
                        layDanhSachMonHoc(query);
                        break;
                    case 2:
                        query = "EXEC TimKiem_Lop '" + search + "'";
                        layDanhSachLop(query);
                        break;
                    case 3:
                        query = "EXEC TimKiem_GiangVien '" + search + "'";
                        layDanhSachGiangVien(query);
                        break;
                    case 4:
                        query = "EXEC TimKiem_LopMonHoc '" + search + "'";
                        layDanhSachLopTheoMon(query);
                        break;
                    case 5:
                        query = "EXEC TimKiem_SinhVien_TheoMaSV '" + search + "'";
                        layDanhSachSinhVien(query);
                        break;
                }
                btnHuyKQ.Visible = true;
            }
            else
                MessageBox.Show("Bạn cần nhập đủ thông tin để tìm kiếm", "Thông báo", MessageBoxButtons.OK, MessageBoxIcon.Warning);
        }

        private void TraCuu_Form_Load(object sender, EventArgs e)
        {
            layDuLieu();
        }
    }
}
