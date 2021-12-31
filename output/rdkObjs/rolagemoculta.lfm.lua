require("firecast.lua");
local __o_rrpgObjs = require("rrpgObjs.lua");
require("rrpgGUI.lua");
require("rrpgDialogs.lua");
require("rrpgLFM.lua");
require("ndb.lua");
require("locale.lua");
local __o_Utils = require("utils.lua");

local function constructNew_rolagemoculta()
    local obj = GUI.fromHandle(_obj_newObject("form"));
    local self = obj;
    local sheet = nil;

    rawset(obj, "_oldSetNodeObjectFunction", rawget(obj, "setNodeObject"));

    function obj:setNodeObject(nodeObject)
        sheet = nodeObject;
        self.sheet = nodeObject;
        self:_oldSetNodeObjectFunction(nodeObject);
    end;

    function obj:setNodeDatabase(nodeObject)
        self:setNodeObject(nodeObject);
    end;

    _gui_assignInitialParentForForm(obj.handle);
    obj:beginUpdate();
    obj:setName("rolagemoculta");
    obj:setFormType("tablesDock");
    obj:setDataType("rolagemoculta");
    obj:setTitle("Rolagem Oculta");
    obj:setAlign("client");
    obj:setTheme("dark");


        --Rolagem oculta
                function rolagemdedados()
                        local mesaDoPersonagem = Firecast.getMesaDe(sheet);
                        msg = ""; 
                        qtdados = sheet.qtdados;
                        vldados = sheet.vldados;
                        dado = qtdados .. "D" .. vldados
                        rolagem = Firecast.interpretarRolagem(dado); 
                        rolagem:rolarLocalmente();

                        for i = 1, #rolagem.ops, 1 do  
                                local operacao = rolagem.ops[i];      

                                if operacao.tipo == "dado" then        
                                        msg = msg .. operacao.quantidade .. "d" .. operacao.face .. ": \n  ";               

                                        for j = 1, #operacao.resultados, 1 do
                                                msg = msg .. "  " .. operacao.resultados[j];
                                        end;               

                                        msg = msg .. "\n";
                                elseif operacao.tipo == "imediato" then
                                        msg = msg .. "Valor imediato: " .. operacao.valor .. "\n";
                                end;
                        end; 

                        msg = msg .. "------------------- \nResultado Somado: " .. rolagem.resultado; 

                        showMessage(msg);
                        mesaDoPersonagem.chat:enviarMensagem("O narrador rolou os dados...");

                end;


        --Adicionar qt. dado
                function dadomaisqt()
                        sheet.qtdados = (sheet.qtdados or 0) + 1;
                        end;
        --Remover vl. dado
        


 
                function dadomenosqt()
                        sheet.qtdados = (sheet.qtdados or 0) - 1;
                                if sheet.qtdados < 0 then
                                sheet.qtdados = 0;
                                end;
                        end;
        


    obj.layout1 = GUI.fromHandle(_obj_newObject("layout"));
    obj.layout1:setParent(obj);
    obj.layout1:setLeft(30);
    obj.layout1:setTop(10);
    obj.layout1:setWidth(300);
    obj.layout1:setHeight(300);
    obj.layout1:setName("layout1");

    obj.edit1 = GUI.fromHandle(_obj_newObject("edit"));
    obj.edit1:setParent(obj.layout1);
    obj.edit1:setLeft(0);
    obj.edit1:setTop(64);
    obj.edit1:setField("qtdados");
    obj.edit1:setReadOnly(false);
    obj.edit1:setType("number");
    obj.edit1:setMin(0);
    obj.edit1:setName("edit1");

    obj.comboBox1 = GUI.fromHandle(_obj_newObject("comboBox"));
    obj.comboBox1:setParent(obj.layout1);
    obj.comboBox1:setLeft(100);
    obj.comboBox1:setTop(42);
    obj.comboBox1:setWidth(70);
    obj.comboBox1:setHeight(75);
    obj.comboBox1:setField("vldados");
    obj.comboBox1:setItems({'D4', 'D6', 'D8', 'D10', 'D12', 'D20', 'D100'});
    obj.comboBox1:setValues({'4', '6', '8', '10', '12', '20', '100'});
    obj.comboBox1:setName("comboBox1");

    obj.button1 = GUI.fromHandle(_obj_newObject("button"));
    obj.button1:setParent(obj.layout1);
    obj.button1:setLeft(0);
    obj.button1:setTop(42);
    obj.button1:setWidth(100);
    obj.button1:setText("+");
    obj.button1:setName("button1");

    obj.button2 = GUI.fromHandle(_obj_newObject("button"));
    obj.button2:setParent(obj.layout1);
    obj.button2:setLeft(0);
    obj.button2:setTop(96);
    obj.button2:setWidth(100);
    obj.button2:setText("-");
    obj.button2:setName("button2");

    obj.button3 = GUI.fromHandle(_obj_newObject("button"));
    obj.button3:setParent(obj.layout1);
    obj.button3:setLeft(60);
    obj.button3:setTop(160);
    obj.button3:setWidth(100);
    obj.button3:setText("Rolar");
    obj.button3:setName("button3");

    obj._e_event0 = obj.button1:addEventListener("onClick",
        function (_)
            dadomaisqt()
        end, obj);

    obj._e_event1 = obj.button2:addEventListener("onClick",
        function (_)
            dadomenosqt()
        end, obj);

    obj._e_event2 = obj.button3:addEventListener("onClick",
        function (_)
            rolagemdedados()
        end, obj);

    function obj:_releaseEvents()
        __o_rrpgObjs.removeEventListenerById(self._e_event2);
        __o_rrpgObjs.removeEventListenerById(self._e_event1);
        __o_rrpgObjs.removeEventListenerById(self._e_event0);
    end;

    obj._oldLFMDestroy = obj.destroy;

    function obj:destroy() 
        self:_releaseEvents();

        if (self.handle ~= 0) and (self.setNodeDatabase ~= nil) then
          self:setNodeDatabase(nil);
        end;

        if self.layout1 ~= nil then self.layout1:destroy(); self.layout1 = nil; end;
        if self.button3 ~= nil then self.button3:destroy(); self.button3 = nil; end;
        if self.edit1 ~= nil then self.edit1:destroy(); self.edit1 = nil; end;
        if self.button1 ~= nil then self.button1:destroy(); self.button1 = nil; end;
        if self.comboBox1 ~= nil then self.comboBox1:destroy(); self.comboBox1 = nil; end;
        if self.button2 ~= nil then self.button2:destroy(); self.button2 = nil; end;
        self:_oldLFMDestroy();
    end;

    obj:endUpdate();

    return obj;
end;

function newrolagemoculta()
    local retObj = nil;
    __o_rrpgObjs.beginObjectsLoading();

    __o_Utils.tryFinally(
      function()
        retObj = constructNew_rolagemoculta();
      end,
      function()
        __o_rrpgObjs.endObjectsLoading();
      end);

    assert(retObj ~= nil);
    return retObj;
end;

local _rolagemoculta = {
    newEditor = newrolagemoculta, 
    new = newrolagemoculta, 
    name = "rolagemoculta", 
    dataType = "rolagemoculta", 
    formType = "tablesDock", 
    formComponentName = "form", 
    title = "Rolagem Oculta", 
    description=""};

rolagemoculta = _rolagemoculta;
Firecast.registrarForm(_rolagemoculta);
Firecast.registrarDataType(_rolagemoculta);
Firecast.registrarSpecialForm(_rolagemoculta);

return _rolagemoculta;
