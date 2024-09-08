﻿
#Область СлужебныйПрограммныйИнтерфейс

// Добавляет в список поставляемые драйверы в составе конфигурации.
//
// Параметры:
//  ДрайвераОборудования - см. МенеджерОборудования.НоваяТаблицаПоставляемыхДрайверовОборудования
//
Процедура ОбновитьПоставляемыеДрайвера(ДрайвераОборудования) Экспорт
	
	Драйвер = ДрайвераОборудования.Добавить();
	Драйвер.ТипОборудования = Перечисления.ТипыПодключаемогоОборудования.СканерШтрихкода;
	Драйвер.ИмяДрайвера  = "Драйвер1ССканерыШтрихкодаNative";
	Драйвер.Наименование = НСтр("ru = '1С:Сканеры штрихкода (Native Api)'", ОбщегоНазначенияБПО.КодОсновногоЯзыка());
	Драйвер.ИдентификаторОбъекта = "InputDevice"; 
	Драйвер.ВерсияДрайвера = "10.5.2.2";
	Драйвер.ИмяМакетаДрайвера = "Драйвер1СУстройстваВводаNative";
	
	// ++ НеМобильноеПриложение
	Драйвер = ДрайвераОборудования.Добавить();
	Драйвер.ТипОборудования = Перечисления.ТипыПодключаемогоОборудования.СчитывательМагнитныхКарт;
	Драйвер.ИмяДрайвера  = "Драйвер1ССчитывателиМагнитныхКартNative";
	Драйвер.Наименование = НСтр("ru = '1С:Считыватели магнитных карт (Native Api)'", ОбщегоНазначенияБПО.КодОсновногоЯзыка());
	Драйвер.ИдентификаторОбъекта = "InputDevice"; 
	Драйвер.ВерсияДрайвера = "10.5.2.1";
	Драйвер.ИмяМакетаДрайвера = "Драйвер1СУстройстваВводаNative";
	// -- НеМобильноеПриложение 
	// ++ Локализация      
	
	Драйвер = ДрайвераОборудования.Добавить();
	Драйвер.ТипОборудования = Перечисления.ТипыПодключаемогоОборудования.СканерШтрихкода;
	Драйвер.ИмяДрайвера  = "ДрайверRightScanУстройстваВвода";
	Драйвер.Наименование = НСтр("ru = 'RightScan:Устройства ввода данных ТСД Urovo'", ОбщегоНазначенияБПО.КодОсновногоЯзыка());
	Драйвер.ИдентификаторОбъекта = "RSDriver"; 
	Драйвер.ВерсияДрайвера = "1.20";              
	
	Драйвер = ДрайвераОборудования.Добавить();
	Драйвер.ТипОборудования = Перечисления.ТипыПодключаемогоОборудования.СканерШтрихкода;
	Драйвер.ИмяДрайвера  = "ДрайверСканкодСканерШтрихкода";
	Драйвер.Наименование = НСтр("ru = 'Сканкод:Cканер штрихкода Chipherlab ТСД'", ОбщегоНазначенияБПО.КодОсновногоЯзыка());
	Драйвер.ИдентификаторОбъекта = "ScancodeBarcodeScannerCPT"; 
	Драйвер.ВерсияДрайвера = "1.2.1.1";              
	
	Драйвер = ДрайвераОборудования.Добавить();
	Драйвер.ТипОборудования = Перечисления.ТипыПодключаемогоОборудования.СканерШтрихкода;
	Драйвер.ИмяДрайвера  = "ДрайверScanPortУстройстваВвода";
	Драйвер.Наименование = НСтр("ru = 'ScanPort:Устройства ввода данных ТСД'", ОбщегоНазначенияБПО.КодОсновногоЯзыка());
	Драйвер.ИдентификаторОбъекта = "ScanportScanner"; 
	Драйвер.ВерсияДрайвера = "5.0.0.0";   
	
	Драйвер = ДрайвераОборудования.Добавить();
	Драйвер.ТипОборудования = Перечисления.ТипыПодключаемогоОборудования.СканерШтрихкода;
	Драйвер.ИмяДрайвера  = "ДрайверСканситиУстройстваВвода";
	Драйвер.Наименование = НСтр("ru = 'Скансити:Устройства ввода данных ТСД'", ОбщегоНазначенияБПО.КодОсновногоЯзыка());
	Драйвер.ИдентификаторОбъекта = "ScanCityNewlandBarcode"; 
	Драйвер.ВерсияДрайвера = "1.0.1.3";   
	
	Драйвер = ДрайвераОборудования.Добавить();
	Драйвер.ТипОборудования = Перечисления.ТипыПодключаемогоОборудования.СканерШтрихкода;
	Драйвер.ИмяДрайвера  = "ДрайверКлеверенсСканерШтрихкода";
	Драйвер.Наименование = НСтр("ru = 'Клеверенс:Драйвер ТСД для мобильной платформы 1С'", ОбщегоНазначенияБПО.КодОсновногоЯзыка());
	Драйвер.ИдентификаторОбъекта = "CleverenceBarcodeScanner"; 
	Драйвер.ВерсияДрайвера = "1.1.0.6";   
	
	Драйвер = ДрайвераОборудования.Добавить();
	Драйвер.ТипОборудования = Перечисления.ТипыПодключаемогоОборудования.СканерШтрихкода;
	Драйвер.ИмяДрайвера  = "ДрайверАТОЛСканерШтрихкода";
	Драйвер.Наименование = НСтр("ru = 'АТОЛ:Устройства ввода данных ТСД'", ОбщегоНазначенияБПО.КодОсновногоЯзыка());
	Драйвер.ИдентификаторОбъекта = "ru_atol_BarcodeServiceExtension"; 
	Драйвер.ВерсияДрайвера = "1.0.6.0";     
	
	Драйвер = ДрайвераОборудования.Добавить();
	Драйвер.ТипОборудования = Перечисления.ТипыПодключаемогоОборудования.СканерШтрихкода;
	Драйвер.ИмяДрайвера  = "ДрайверMERTECHСканерШтрихкода";
	Драйвер.Наименование = НСтр("ru = 'MERTECH:Сканер штрихкода ТСД'", ОбщегоНазначенияБПО.КодОсновногоЯзыка());
	Драйвер.ИдентификаторОбъекта = "ru_mertech_AndroidScannerExtension"; 
	Драйвер.ВерсияДрайвера = "1.3.0.0";  
	
	// ++ НеМобильноеПриложение
	Драйвер = ДрайвераОборудования.Добавить();
	Драйвер.ТипОборудования = Перечисления.ТипыПодключаемогоОборудования.СканерШтрихкода;
	Драйвер.ИмяДрайвера  = "ДрайверГексагонСканерыШтрихкода";
	Драйвер.Наименование = НСтр("ru = 'Гексагон:Сканеры штрихкода Proton'", ОбщегоНазначенияБПО.КодОсновногоЯзыка());
	Драйвер.ИдентификаторОбъекта = "ProtonScanner"; 
	Драйвер.СнятСПоддержки = Истина; 
	
	Драйвер = ДрайвераОборудования.Добавить();
	Драйвер.ТипОборудования = Перечисления.ТипыПодключаемогоОборудования.СканерШтрихкода;
	Драйвер.ИмяДрайвера  = "ДрайверАтолСканерыШтрихкода8X";
	Драйвер.Наименование = НСтр("ru = 'АТОЛ:Сканеры штрихкода 8.X'", ОбщегоНазначенияБПО.КодОсновногоЯзыка());
	Драйвер.ИдентификаторОбъекта = "ATOL_Scaners_1CInt"; 
	Драйвер.ИмяМакетаДрайвера = "ДрайверАТОЛУстройстваВвода8X";
	
	Драйвер = ДрайвераОборудования.Добавить();
	Драйвер.ТипОборудования = Перечисления.ТипыПодключаемогоОборудования.СчитывательМагнитныхКарт;
	Драйвер.ИмяДрайвера  = "ДрайверАтолСчитывателиМагнитныхКарт8X";
	Драйвер.Наименование = НСтр("ru = 'АТОЛ:Считыватели магнитных карт 8.X'", ОбщегоНазначенияБПО.КодОсновногоЯзыка());
	Драйвер.ИдентификаторОбъекта = "ATOL_Scaners_1CInt"; 
	Драйвер.ИмяМакетаДрайвера = "ДрайверАТОЛУстройстваВвода8X";
	
	Драйвер = ДрайвераОборудования.Добавить();
	Драйвер.ТипОборудования = Перечисления.ТипыПодключаемогоОборудования.СчитывательМагнитныхКарт;
	Драйвер.ИмяДрайвера  = "ДрайверIronLogicСчитывателиБесконтактныхКарт";
	Драйвер.Наименование = НСтр("ru = 'Iron Logic:Считыватели бесконтактных карт Z-2'", ОбщегоНазначенияБПО.КодОсновногоЯзыка());
	Драйвер.ИдентификаторОбъекта = "ZR1CExtension"; 
	Драйвер.ВерсияДрайвера = "1.5.2.1"; 
	
	Драйвер = ДрайвераОборудования.Добавить();
	Драйвер.ТипОборудования = Перечисления.ТипыПодключаемогоОборудования.СчитывательМагнитныхКарт;
	Драйвер.ИмяДрайвера  = "ДрайверРусГардСчитывательМагнитныхКарт";
	Драйвер.Наименование = НСтр("ru = 'Рус-Гард:Считыватель магнитных карт'", ОбщегоНазначенияБПО.КодОсновногоЯзыка());
	Драйвер.ИдентификаторОбъекта = "RgReaderExtension"; 
	Драйвер.ВерсияДрайвера = "4.1";     
	// -- НеМобильноеПриложение     
	// -- Локализация
	
КонецПроцедуры

#КонецОбласти