// test commit

package com.example.jesscat.bindechexmobileapp;

import android.app.AlertDialog;
import android.content.DialogInterface;
import android.support.v7.app.AppCompatActivity;
import android.os.Bundle;
import android.view.Menu;
import android.view.MenuItem;
import android.view.View;
import android.view.ViewGroup;
import android.widget.EditText;
import android.widget.RadioButton;
import android.widget.RadioGroup;
import android.widget.TextView;

public class MainActivity extends AppCompatActivity {

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_main);
    }

    @Override
    public boolean onCreateOptionsMenu(Menu menu) {
        // Inflate the menu; this adds items to the action bar if it is present.
        getMenuInflater().inflate(R.menu.menu_main, menu);
        return true;
    }

    @Override
    public boolean onOptionsItemSelected(MenuItem item) {
        // Handle action bar item clicks here. The action bar will
        // automatically handle clicks on the Home/Up button, so long
        // as you specify a parent activity in AndroidManifest.xml.
        int id = item.getItemId();

        //noinspection SimplifiableIfStatement
        if (id == R.id.action_settings) {
            return true;
        }

        return super.onOptionsItemSelected(item);
    }

    public void convertButtonClick(View view) {

        EditText convertText = (EditText)findViewById(R.id.convertText);
        RadioGroup radioGroup = (RadioGroup)findViewById(R.id.radioGroup);
        TextView binaryText = (TextView)findViewById(R.id.binaryText);
        TextView decimalText = (TextView)findViewById(R.id.decimalText);
        TextView hexadecimalText = (TextView)findViewById(R.id.hexadecimalText);

        String givenText = convertText.getText().toString();
        int state = radioGroup.getCheckedRadioButtonId();

        if (!givenText.isEmpty()) {

            int value = 0;
            int temp = 0;
            if (state == R.id.binaryMode) {
                System.out.println("*** Binary selected.");
                if (givenText.matches("-?[0-1]+")) {
                    // Binary to Binary
                    binaryText.setText(givenText.toCharArray(), 0, givenText.length());

                    // Binary to Decimal
                    for (int i = givenText.length() - 1; i >= 0; i--)
                        temp = temp + (Character.digit(givenText.charAt(i), 10) * (int)Math.pow(2, givenText.length() - 1 - i));
                    decimalText.setText(Integer.toString(temp, 10).toCharArray(), 0, Integer.toString(temp).length());

                    // Binary to Hexadecimal

                    String hexText = decimalToHexadecimal(temp);
                    hexadecimalText.setText(hexText.toCharArray(), 0, hexText.length());

                } else {
                    displayMessage("Warning", "Invalid binary input.");
                }

            } else if (state == R.id.decimalMode) {
                System.out.println("*** Decimal selected.");
                if (givenText.matches("-?[0-9]+")) {
                    // Decimal to Decimal
                    decimalText.setText(givenText.toCharArray(), 0, givenText.length());

                    // Decimal to Binary
                    String decText = decimalToBinary(Integer.parseInt(givenText));
                    binaryText.setText(decText.toCharArray(), 0, decText.length());

                    // Decimal to Hexadecimal
                    String hexText = decimalToHexadecimal(Integer.parseInt(givenText));
                    hexadecimalText.setText(hexText.toCharArray(), 0, hexText.length());

                } else {
                    displayMessage("Warning", "Invalid decimal input.");
                }

            } else if (state == R.id.hexadecimalMode) {
                System.out.println("*** Hexadecimal selected.");
                if (givenText.matches("-?[0-9a-fA-F]+")) {
                    // Hexadecimal to Hexadecimal
                    hexadecimalText.setText(givenText.toCharArray(), 0, givenText.length());

                    // Hexadecimal to Decimal
                    for (int i = givenText.length() - 1; i >= 0; i--) {
                        int charAtIndex;
                        char c = givenText.charAt(i);
                        if (c == 'A' || c == 'a') charAtIndex = 10;
                        else if (c == 'B' || c == 'b') charAtIndex = 11;
                        else if (c == 'C' || c == 'c') charAtIndex = 12;
                        else if (c == 'D' || c == 'd') charAtIndex = 13;
                        else if (c == 'E' || c == 'e') charAtIndex = 14;
                        else if (c == 'F' || c == 'f') charAtIndex = 15;
                        else charAtIndex = Character.digit(givenText.charAt(i), 10);

                        temp = temp + (charAtIndex) * (int) Math.pow(16, givenText.length() - 1 - i);
                    }

                    decimalText.setText(Integer.toString(temp).toCharArray(), 0, Integer.toString(temp).length());

                    // Hexadecimal to Binary
                    String decText = decimalToBinary(temp);
                    binaryText.setText(decText.toCharArray(), 0, decText.length());

                } else {
                    displayMessage("Warning", "Invalid hexadecimal input.");
                }

            } else {
                displayMessage("Warning", "Input is empty.");
            }
        }
    }

    public void clearButtonClick(View view) {
        TextView binaryText = (TextView)findViewById(R.id.binaryText);
        TextView decimalText = (TextView)findViewById(R.id.decimalText);
        TextView hexadecimalText = (TextView)findViewById(R.id.hexadecimalText);

        binaryText.setText("0".toCharArray(), 0, 1);
        decimalText.setText("0".toCharArray(), 0, 1);
        hexadecimalText.setText("0".toCharArray(), 0, 1);

    }

    public void displayMessage(String title, String msg)
    {
        // not implemented. the below seems to crash the app.
        //new AlertDialog.Builder(getApplicationContext())
        //.setTitle(title)
        //.setMessage(msg)
        //.setPositiveButton(android.R.string.ok, new DialogInterface.OnClickListener() {
        //    public void onClick(DialogInterface dialog, int which) {
        //        // continue with delete
        //    }
        // })
        //.setIcon(android.R.drawable.ic_dialog_alert)
        // .show();

    }

    public String decimalToBinary(int decimal)
    {
        System.out.println("Step1.");
        float decimalCopy = (float)decimal;
        System.out.println("Step1.1.");
        float temp;
        System.out.println("Step1.3");
        StringBuilder hexString = new StringBuilder();
        System.out.println("Step1.4");

        while (decimalCopy > 0)
        {
            temp = (float)decimalCopy / 2.0f;

            float remainder = temp - (int)temp;

            // Store the floor of temp in decimalCopy.
            decimalCopy = temp - remainder;

            // Multiply by 16 to get true remainder.
            remainder *= 2.0f;

            char c;
            if (remainder == 0) c = '0';
            else c = '1';
            System.out.println("Step2.");
            hexString.insert(0, c);
        }

        System.out.println("Step3.");
        return hexString.toString();
    }

    public String decimalToHexadecimal(int decimal)
    {
        float decimalCopy = (float)decimal;
        float temp;
        StringBuilder hexString = new StringBuilder();

        while (decimalCopy > 0)
        {
            temp = (float)decimalCopy / 16.0f;

            float remainder = temp - (int)temp;

            // Store the floor of temp in decimalCopy.
            decimalCopy = temp - remainder;

            // Multiply by 16 to get true remainder.
            remainder *= 16.0f;

            char c;
            if (remainder == 10) c = 'A';
            else if (remainder == 11) c = 'B';
            else if (remainder == 12) c = 'C';
            else if (remainder == 13) c = 'D';
            else if (remainder == 14) c = 'E';
            else if (remainder == 15) c = 'F';
            else c = (char)(remainder + '0');

            hexString.insert(0, c);
        }

        return hexString.toString();
    }

}
