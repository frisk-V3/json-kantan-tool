import js.Browser;
import js.html.DivElement;
import js.html.InputElement;
import js.html.TextAreaElement;
import haxe.Json;
import haxe.DynamicAccess;

class Main {
    static var container:DivElement;
    static var output:TextAreaElement;

    static function main() {
        // HTMLが読み込まれるのを待って初期化
        Browser.window.onload = _ -> {
            setupUI();
        };
    }

    static function setupUI() {
        var doc = Browser.document;
        container = cast doc.getElementById("input-container");
        output = cast doc.getElementById("json-output");

        addRow();

        doc.getElementById("add-row-btn").onclick = _ -> addRow();
        doc.getElementById("generate-btn").onclick = _ -> generateJson();
        doc.getElementById("copy-btn").onclick = _ -> copyToClipboard();
    }

    static function addRow() {
        var row = Browser.document.createDivElement();
        row.className = "row";
        row.innerHTML = '
            <input type="text" class="key" placeholder="キー (例: name)">
            <input type="text" class="value" placeholder="値 (例: 100 or 勇者)">
            <button class="remove-btn" onclick="this.parentElement.remove()">×</button>
        ';
        container.appendChild(row);
    }

    static function generateJson() {
        var data:DynamicAccess<Dynamic> = {};
        var rows = container.getElementsByClassName("row");

        for (i in 0...rows.length) {
            var row = rows[i];
            var key:String = cast(row.querySelector(".key"), InputElement).value;
            var valStr:String = cast(row.querySelector(".value"), InputElement).value;

            if (key == "") continue; // キーが空ならスキップ

            var value:Dynamic = valStr;
            if (valStr.toLowerCase() == "true") value = true;
            else if (valStr.toLowerCase() == "false") value = false;
            else if (!Math.isNaN(Std.parseFloat(valStr))) value = Std.parseFloat(valStr);

            data.set(key, value);
        }
        output.value = Json.stringify(data, null, "  ");
    }

    static function copyToClipboard() {
        output.select();
        Browser.document.execCommand("copy");
        Browser.window.alert("コピーしました！");
    }
}
