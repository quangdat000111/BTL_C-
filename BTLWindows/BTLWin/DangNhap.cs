using Data;
using System;
using System.Collections.Generic;
using System.ComponentModel;
using System.Data;
using System.Drawing;
using System.Linq;
using System.Text;
using System.Threading;
using System.Threading.Tasks;
using System.Windows.Forms;

namespace BTLWin
{
    public partial class DangNhap : Form
    {
        bool mov;
        int movX, movY;
        public DangNhap()
        {
            InitializeComponent();
        }

        private void btnExit_Click(object sender, EventArgs e)
        {
            Application.Exit();
        }

        private void btnMinimized_Click(object sender, EventArgs e)
        {
            //Ẩn form xuống thanh taskbar
            this.WindowState = FormWindowState.Minimized;
        }

        private void panel1_MouseDown(object sender, MouseEventArgs e)
        {
            //Khi ấn chuột xuống lấy tọa độ của chuột so với form
            movX = e.X;
            movY = e.Y;
            mov = true;
        }

        private void panel1_MouseUp(object sender, MouseEventArgs e)
        {
            //Nhả chuột ra
            mov = false;
        }

        private void DangNhap_Load(object sender, EventArgs e)
        {
            //Hiển thị mật khẩu
            if (chkHienThiMK.Checked)
            {
                txtMatKhau.UseSystemPasswordChar = false;
            }
            lblSaiTKorMK.Visible = false;//Ẩn thông báo sai mk hoặc tên đăng nhập
        }

        private void txtDangNhap_Validating(object sender, CancelEventArgs e)
        {
            if (lblSaiTKorMK.Visible == true)
            {
                lblSaiTKorMK.Visible = false;
            }
            if (txtDangNhap.Text == "")
            {
                errorProvider1.SetError(txtDangNhap, "Tên đăng nhập đang bị bỏ trống");
                txtDangNhap.Focus();
            }
            else
            {
                errorProvider1.SetError(txtDangNhap, "");
                e.Cancel = false;
            }
        }

        private void txtMatKhau_Validating(object sender, CancelEventArgs e)
        {
            if (lblSaiTKorMK.Visible == true)
            {
                lblSaiTKorMK.Visible = false;
            }
            if (txtMatKhau.Text == "")
            {
                errorProvider2.SetError(txtMatKhau, "Mật khẩu đang bị bỏ trống");
                txtMatKhau.Focus();
            }
            else
            {
                errorProvider2.SetError(txtMatKhau, "");
                e.Cancel = false;
            }
        }

        private void chkHienThiMK_CheckedChanged(object sender, EventArgs e)
        {

            if (chkHienThiMK.Checked)
            {
                txtMatKhau.UseSystemPasswordChar = false;
                //txtMatKhau.PasswordChar = '\0';
            }
            else
            {
                txtMatKhau.UseSystemPasswordChar = true;
                //txtMatKhau.PasswordChar = '*';
            }
        }

        private void btnDangNhap_Click(object sender, EventArgs e)
        {

            DataTable table = new Database().SelectData("EXEC DangNhap_GV '" + txtDangNhap.Text + "', '" + txtMatKhau.Text + "'");
            if(table != null)
            {
                if (table.Rows.Count != 0)
                {
                    this.Hide();
                    //Truyền tên đăng nhập, mật khẩu và mã giáo viên vào main form
                    new MainForm(txtDangNhap.Text, txtMatKhau.Text, table.Rows[0][2].ToString(), 2).ShowDialog();
                    this.Close();
                }
                else
                {
                    lblSaiTKorMK.Visible = true;
                }
            }
        }
        private void panel1_MouseMove(object sender, MouseEventArgs e)
        {
            if (mov)// Nêu chuột còn đang được ấn xuống và di chuyển
            {
                this.SetDesktopLocation(MousePosition.X - movX, MousePosition.Y - movY);
                //MousePosition là vị trí của chuột so với màn hình 
            }
        }
    }
}
