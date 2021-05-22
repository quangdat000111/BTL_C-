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
    public partial class MainForm : Form
    {
        bool mov;
        int movX, movY, accountType;

        Form currentChildForm;
        Button currentButton;
        string userName, password, id;
        public MainForm()
        {
            InitializeComponent();
        }
        public MainForm(string userName, string password, string id, int accountType)
        {
            InitializeComponent();
            this.userName = userName;
            this.password = password;
            this.id = id;
            this.accountType = accountType;
        }
        private void btnMaximized_Click(object sender, EventArgs e)
        {
            if (this.WindowState != FormWindowState.Maximized)
            {
                this.WindowState = FormWindowState.Maximized;
            }
            else
            {
                this.WindowState = FormWindowState.Normal;
            }
        }

        private void btnExit_Click(object sender, EventArgs e)
        {
            Application.Exit();
        }

        private void btnMinimized_Click(object sender, EventArgs e)
        {
            this.WindowState = FormWindowState.Minimized;
        }

        private void panelTitleBar_MouseUp(object sender, MouseEventArgs e)
        {
            mov = false;
        }
        private void MainForm_Load(object sender, EventArgs e)
        {
            this.Text = String.Empty;
            this.lblWelcome.Text = "Chào mừng, " + this.userName;
            this.ControlBox = false;
            this.DoubleBuffered = true;
            this.MaximizedBounds = Screen.FromHandle(Handle).WorkingArea;
            panel2.Visible = false;
            panel3.Visible = false;
            activeChildForm(new TrangChu_Form(id));
            activeButton(btnTrangChu, Color.CadetBlue);
            switch (accountType)
            {
                case 0:
                    btnQuanLy.Text = "Kết quả học tập";
                    break;
                case 2:
                    btnQuanLy.Visible = false;
                    break;
            }
            btnQuanLy.Visible = true;
        }

        private void btnMonHoc_Submenu_Click(object sender, EventArgs e)
        {
            activeButton(sender, Color.CadetBlue);
            activeChildForm(new TraCuu_Form(1));
        }

        private void btnLopHoc_Submenu_Click(object sender, EventArgs e)
        {
            activeButton(sender, Color.CadetBlue);
            activeChildForm(new TraCuu_Form(2));
        }

        private void btnGiangVien_Submenu_Click(object sender, EventArgs e)
        {
            activeButton(sender, Color.CadetBlue);
            activeChildForm(new TraCuu_Form(3));
        }

        private void btnLopTheoMon_Submenu_Click(object sender, EventArgs e)
        {
            activeButton(sender, Color.CadetBlue);
            activeChildForm(new TraCuu_Form(4));
        }

        private void btnWebsite_Submenu_Click(object sender, EventArgs e)
        {
            activeButton(sender, Color.CadetBlue);
            System.Diagnostics.Process.Start("chrome.exe", "https://www.haui.edu.vn");
        }

        private void btnFacebook_Submenu_Click(object sender, EventArgs e)
        {
            activeButton(sender, Color.CadetBlue);
            System.Diagnostics.Process.Start("chrome.exe", "https://www.facebook.com/DHCNHN.DCN.HaUI");
        }

        private void btnTraCuu_Click(object sender, EventArgs e)
        {
            if(panel2.Visible == false)
            {
                panel2.Visible = true;
            }
            else
            {
                panel2.Visible = false;
            }
        }

        private void btnHoTro_Click(object sender, EventArgs e)
        {
            if (panel3.Visible == false)
            {
                panel3.Visible = true;
            }
            else
            {
                panel3.Visible = false;
            }
        }

        public void activeChildForm(Form newForm)
        {
            if(currentChildForm != null)
            {
                currentChildForm.Close();
            }
            newForm.FormBorderStyle = FormBorderStyle.None;
            currentChildForm = newForm;
            newForm.TopLevel = false;
            //A top-level form is a window that has no parent form, or whose parent form is the desktop window. 
            //Top-level windows are typically used as the main form in an application.True to display the form as a top-level window; otherwise, false. 
            //The default is true.
            //Top level của 1 form mặc định là true. Nếu TopLvel = true thì form đó sẽ không có form cha mẹ hoặc form cha mẹ là màn hình desktop
            //Ví dụ như MainForm có parents = desktop window
            newForm.Dock = DockStyle.Fill;
            //Kích thước của form sẽ tự động điều chỉnh theo parents
            panelChildForm.Controls.Add(newForm);
            //Thêm form vào panel panelChildForm như là 1 controls
            panelChildForm.Tag = newForm; 
            //The Tag property stores an object reference. Windows Forms programs can use object 
            //models of arbitrary complexity.But the Tag property is a simple way to link a certain object to a certain control.
            //It is useful in certain situations
            newForm.BringToFront();
            newForm.Show();
        }

        public void activeButton(object sender, Color color)
        {
            //Màu mặc định của các button Teal, nếu button đó dc active thì màu của nó sẽ đổi thành màu dc truyền vào
            if(sender != null)
            {
                disableButton();
                currentButton = (Button)sender;
                currentButton.BackColor = color;//LightSeaGreen, CadetBlue
            }    
        }

        private void btnTrangChu_Click(object sender, EventArgs e)
        {
            activeButton(sender, Color.LightSeaGreen);
            activeChildForm(new TrangChu_Form(id));
        }

        private void MainForm_MouseMove(object sender, MouseEventArgs e)
        {
            if(mov)
            {
                this.SetDesktopLocation(MousePosition.X - movX, MousePosition.Y - movY);
            }
        }

        private void MainForm_MouseDown(object sender, MouseEventArgs e)
        {
            mov = true;
            movX = e.X;
            movY = e.Y;
        }

        private void MainForm_MouseUp(object sender, MouseEventArgs e)
        {
            mov = false;
        }

        private void btnDangXuat_Click(object sender, EventArgs e)
        {
            this.Hide();
            new DangNhap().ShowDialog();
            this.Close();
        }

        private void btnSinhVien_Submenu_Click(object sender, EventArgs e)
        {
            activeButton(sender, Color.CadetBlue);
            activeChildForm(new TraCuu_Form(5));
        }
        private void btnTaiKhoan_Click(object sender, EventArgs e)
        {
            activeButton(sender, Color.LightSeaGreen);
            activeChildForm(new TaiKhoan_Form(this.userName, this.password, this.id));
            if(accountType == 2)
            {
                if(btnQuanLyTK.Visible)
                {
                    btnQuanLyTK.Visible = false;
                }
                else
                {
                    btnQuanLyTK.Visible = true;
                }
            }    
        }

        private void btnQuanLy_Click(object sender, EventArgs e)
        {
            activeButton(sender, Color.LightSeaGreen);
            activeChildForm(new QuanLyDiem(userName, password, id));
        }

        public void disableButton()
        {
            if(currentButton != null)
            {
                if (currentButton == btnTrangChu || currentButton == btnTaiKhoan || currentButton == btnQuanLy)
                    currentButton.BackColor = Color.Teal;
                else
                    currentButton.BackColor = Color.DarkSlateGray;
                //Màu mặc định của các button trong submenu 
            }    
        }

        private void btnQuanLyTK_Submenu_Click(object sender, EventArgs e)
        {
            activeButton(sender, Color.CadetBlue);
        }

    }
}
