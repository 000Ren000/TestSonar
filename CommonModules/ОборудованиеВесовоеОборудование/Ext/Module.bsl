﻿
#Область СлужебныйПрограммныйИнтерфейс

// Добавляет в список поставляемые драйверы в составе конфигурации.
// 
// Параметры:
//  ДрайвераОборудования - см. МенеджерОборудования.НоваяТаблицаПоставляемыхДрайверовОборудования
//
Процедура ОбновитьПоставляемыеДрайвера(ДрайвераОборудования) Экспорт
	
	Драйвер = ДрайвераОборудования.Добавить();
	Драйвер.ТипОборудования = Перечисления.ТипыПодключаемогоОборудования.ЭлектронныеВесы;
	Драйвер.ИмяДрайвера  = "Драйвер1СЭлектронныеВесы";
	Драйвер.Наименование = НСтр("ru = '1С:Электронные весы (Native Api)'", ОбщегоНазначенияБПО.КодОсновногоЯзыка());
	Драйвер.ИдентификаторОбъекта = "CheckoutScales"; 
	Драйвер.ВерсияДрайвера = "2.1.1.2";
	
	// ++ НеМобильноеПриложение
	// ++ Локализация
	Драйвер = ДрайвераОборудования.Добавить();
	Драйвер.ТипОборудования = Перечисления.ТипыПодключаемогоОборудования.ЭлектронныеВесы;
	Драйвер.ИмяДрайвера  = "ДрайверCASЭлектронныеВесы";
	Драйвер.Наименование = НСтр("ru = 'CAS:Электронные весы'", ОбщегоНазначенияБПО.КодОсновногоЯзыка());
	Драйвер.ИдентификаторОбъекта = "CasCentreSimpleScale";   
	Драйвер.СнятСПоддержки = Истина; 
	
	Драйвер = ДрайвераОборудования.Добавить();
	Драйвер.ТипОборудования = Перечисления.ТипыПодключаемогоОборудования.ЭлектронныеВесы;
	Драйвер.ИмяДрайвера  = "ДрайверCASЭлектронныеВесы2х";
	Драйвер.Наименование = НСтр("ru = 'CAS:Электронные весы 2.х'", ОбщегоНазначенияБПО.КодОсновногоЯзыка());
	Драйвер.ИдентификаторОбъекта = "CAS_Scale_nLP"; 
	Драйвер.ВерсияДрайвера = "2.14"; 
	
	Драйвер = ДрайвераОборудования.Добавить();
	Драйвер.ТипОборудования = Перечисления.ТипыПодключаемогоОборудования.ЭлектронныеВесы;
	Драйвер.ИмяДрайвера  = "ДрайверАТОЛЭлектронныеВесы8X";
	Драйвер.Наименование = НСтр("ru = 'АТОЛ:Электронные весы 8.Х'", ОбщегоНазначенияБПО.КодОсновногоЯзыка());
	Драйвер.ИдентификаторОбъекта = "ATOL_Scale_1CInt"; 
	
	Драйвер = ДрайвераОборудования.Добавить();
	Драйвер.ТипОборудования = Перечисления.ТипыПодключаемогоОборудования.ЭлектронныеВесы;
	Драйвер.ИмяДрайвера  = "ДрайверМассаКЭлектронныеВесы";
	Драйвер.Наименование = НСтр("ru = 'Масса-К:Электронные весы'", ОбщегоНазначенияБПО.КодОсновногоЯзыка());
	Драйвер.ИдентификаторОбъекта = "MassaKDriverR1C"; 
	Драйвер.ИмяМакетаДрайвера = "ДрайверМассаКЭлектронныеВесыИСПечатьюЭтикеток";
	
	Драйвер = ДрайвераОборудования.Добавить();
	Драйвер.ТипОборудования = Перечисления.ТипыПодключаемогоОборудования.ЭлектронныеВесы;
	Драйвер.ИмяДрайвера  = "ДрайверШтрихМЭлектронныеВесыPOS2";
	Драйвер.Наименование = НСтр("ru = 'ШТРИХ-М:Электронные весы POS2'", ОбщегоНазначенияБПО.КодОсновногоЯзыка());
	Драйвер.ИдентификаторОбъекта = "DrvSM1C"; 
	
	Драйвер = ДрайвераОборудования.Добавить();
	Драйвер.ТипОборудования = Перечисления.ТипыПодключаемогоОборудования.ЭлектронныеВесы;
	Драйвер.ИмяДрайвера  = "ДрайверСервисПлюсЭлектронныеВесы";
	Драйвер.Наименование = НСтр("ru = 'Сервис-Плюс:Электронные весы'", ОбщегоНазначенияБПО.КодОсновногоЯзыка());
	Драйвер.ИдентификаторОбъекта = "Cw100Driver"; 
	
	Драйвер = ДрайвераОборудования.Добавить();
	Драйвер.ТипОборудования = Перечисления.ТипыПодключаемогоОборудования.ЭлектронныеВесы;
	Драйвер.ИмяДрайвера  = "ДрайверМАСЭлектронныеВесы";
	Драйвер.Наименование = НСтр("ru = 'МАС:Электронные весы'", ОбщегоНазначенияБПО.КодОсновногоЯзыка());
	Драйвер.ИдентификаторОбъекта = "ScaleMAS"; 
	
	Драйвер = ДрайвераОборудования.Добавить();
	Драйвер.ТипОборудования = Перечисления.ТипыПодключаемогоОборудования.ЭлектронныеВесы;
	Драйвер.ИмяДрайвера  = "ДрайверМертехЭлектронныеВесы";
	Драйвер.Наименование = НСтр("ru = 'Мертех:Электронные весы'", ОбщегоНазначенияБПО.КодОсновногоЯзыка());
	Драйвер.ИдентификаторОбъекта = "ScalePos2M";
	Драйвер.ВерсияДрайвера = "1.1.30001";
	
	Драйвер = ДрайвераОборудования.Добавить();
	Драйвер.ТипОборудования = Перечисления.ТипыПодключаемогоОборудования.ЭлектронныеВесы;
	Драйвер.ИмяДрайвера  = "ДрайверНАИСЭлектронныеВесы";
	Драйвер.Наименование = НСтр("ru = 'НАИС:Весовые терминалы ВТ'", ОбщегоНазначенияБПО.КодОсновногоЯзыка());
	Драйвер.ИдентификаторОбъекта = "naisTerminals";
	Драйвер.ВерсияДрайвера = "1.4";
	
	Драйвер = ДрайвераОборудования.Добавить();
	Драйвер.ТипОборудования = Перечисления.ТипыПодключаемогоОборудования.ВесыСПечатьюЭтикеток;
	Драйвер.ИмяДрайвера  = "ДрайверCASВесыСПечатьюЭтикеток";
	Драйвер.Наименование = НСтр("ru = 'CAS:Весы с печатью этикеток'", ОбщегоНазначенияБПО.КодОсновногоЯзыка());
	Драйвер.ИдентификаторОбъекта = "CasCentrePrintingScale";  
	Драйвер.СнятСПоддержки = Истина; 
	
	Драйвер = ДрайвераОборудования.Добавить();
	Драйвер.ТипОборудования = Перечисления.ТипыПодключаемогоОборудования.ВесыСПечатьюЭтикеток;
	Драйвер.ИмяДрайвера  = "ДрайверCASВесыСПечатьюЭтикеток2х";
	Драйвер.Наименование = НСтр("ru = 'CAS:Весы с печатью этикеток 2.х'", ОбщегоНазначенияБПО.КодОсновногоЯзыка());
	Драйвер.ИдентификаторОбъекта = "CAS_ScaleLP"; 
	Драйвер.ВерсияДрайвера = "2.19"; 
	
	Драйвер = ДрайвераОборудования.Добавить();
	Драйвер.ТипОборудования = Перечисления.ТипыПодключаемогоОборудования.ВесыСПечатьюЭтикеток;
	Драйвер.ИмяДрайвера  = "ДрайверМассаКВесыСПечатьюЭтикеток";
	Драйвер.Наименование = НСтр("ru = 'Масса-К:Весы с печатью этикеток'", ОбщегоНазначенияБПО.КодОсновногоЯзыка());
	Драйвер.ИдентификаторОбъекта = "MassaKDriverR1C"; 
	Драйвер.ИмяМакетаДрайвера = "ДрайверМассаКЭлектронныеВесыИСПечатьюЭтикеток";
	
	Драйвер = ДрайвераОборудования.Добавить();
	Драйвер.ТипОборудования = Перечисления.ТипыПодключаемогоОборудования.ВесыСПечатьюЭтикеток;
	Драйвер.ИмяДрайвера  = "ДрайверАТОЛВесыСПечатьюЭтикеток8X";
	Драйвер.Наименование = НСтр("ru = 'АТОЛ:Весы c печатью этикеток 8.X'", ОбщегоНазначенияБПО.КодОсновногоЯзыка());
	Драйвер.ИдентификаторОбъекта = "ATOL_ScaleLP_1CInt"; 
	
	Драйвер = ДрайвераОборудования.Добавить();
	Драйвер.ТипОборудования = Перечисления.ТипыПодключаемогоОборудования.ВесыСПечатьюЭтикеток;
	Драйвер.ИмяДрайвера  = "ДрайверРБСВесыCПечатьюЭтикеток";
	Драйвер.Наименование = НСтр("ru = 'РБС:Весы c печатью этикеток KS'", ОбщегоНазначенияБПО.КодОсновногоЯзыка());
	Драйвер.ИдентификаторОбъекта = "Rbs1CDriver"; 
	Драйвер.ВерсияДрайвера = "3.0.2";
	
	Драйвер = ДрайвераОборудования.Добавить();
	Драйвер.ТипОборудования = Перечисления.ТипыПодключаемогоОборудования.ВесыСПечатьюЭтикеток;
	Драйвер.ИмяДрайвера  = "ДрайверШтрихМВесыСПечатьюЭтикетокШтрихПринт";
	Драйвер.Наименование = НСтр("ru = 'ШТРИХ-М:Весы с печатью этикеток ШТРИХ-ПРИНТ'", ОбщегоНазначенияБПО.КодОсновногоЯзыка());
	Драйвер.ИдентификаторОбъекта = "DrvLP1C";      
	Драйвер.СнятСПоддержки = Истина; 
	
	Драйвер = ДрайвераОборудования.Добавить();
	Драйвер.ТипОборудования = Перечисления.ТипыПодключаемогоОборудования.ВесыСПечатьюЭтикеток;
	Драйвер.ИмяДрайвера  = "ДрайверШтрихМВесыСПечатьюЭтикетокШтрихПринтNG";
	Драйвер.Наименование = НСтр("ru = 'ШТРИХ-М:Весы с печатью этикеток ШТРИХ-ПРИНТ NG'", ОбщегоНазначенияБПО.КодОсновногоЯзыка());
	Драйвер.ИдентификаторОбъекта = "ShtrihPrint_drv_ng_V1";      
	Драйвер.ВерсияДрайвера = "1.0.0.2";
	
	Драйвер = ДрайвераОборудования.Добавить();
	Драйвер.ТипОборудования = Перечисления.ТипыПодключаемогоОборудования.ВесыСПечатьюЭтикеток;
	Драйвер.ИмяДрайвера  = "ДрайверBizerbaВесыСПечатьюЭтикеток";
	Драйвер.Наименование = НСтр("ru = 'Bizerba:Драйвер весов с печатью этикеток'", ОбщегоНазначенияБПО.КодОсновногоЯзыка());
	Драйвер.ИдентификаторОбъекта = "BizerbaNative"; 
	
	Драйвер = ДрайвераОборудования.Добавить();
	Драйвер.ТипОборудования = Перечисления.ТипыПодключаемогоОборудования.ВесыСПечатьюЭтикеток;
	Драйвер.ИмяДрайвера  = "ДрайверСервисПлюсВесыСПечатьюЭтикеток";
	Драйвер.Наименование = НСтр("ru = 'Сервис-Плюс:Весы с печатью этикеток'", ОбщегоНазначенияБПО.КодОсновногоЯзыка());
	Драйвер.ИдентификаторОбъекта = "Sm320Driver"; 
	
	Драйвер = ДрайвераОборудования.Добавить();
	Драйвер.ТипОборудования = Перечисления.ТипыПодключаемогоОборудования.ЭлектронныеВесы;
	Драйвер.ИмяДрайвера  = "ДрайверМертехЭлектронныеВесыУстройствоРаспознавания";
	Драйвер.Наименование = НСтр("ru = 'Мертех:Электронные весы (Распознаватель)'", ОбщегоНазначенияБПО.КодОсновногоЯзыка());
	Драйвер.ИдентификаторОбъекта = "Mertech";        
	Драйвер.ИмяМакетаДрайвера = "ДрайверМертехВесыСПечатьюЭтикетокРаспознаватель";
	
	Драйвер = ДрайвераОборудования.Добавить();
	Драйвер.ТипОборудования = Перечисления.ТипыПодключаемогоОборудования.ВесыСПечатьюЭтикеток;
	Драйвер.ИмяДрайвера  = "ДрайверМертехВесыСПечатьюЭтикетокРаспознаватель";
	Драйвер.Наименование = НСтр("ru = 'Мертех:Весы с печатью этикеток (Распознаватель)'", ОбщегоНазначенияБПО.КодОсновногоЯзыка());
	Драйвер.ИдентификаторОбъекта = "Mertech";        
	Драйвер.ИмяМакетаДрайвера = "ДрайверМертехВесыСПечатьюЭтикетокРаспознаватель";
	
	Драйвер = ДрайвераОборудования.Добавить();
	Драйвер.ТипОборудования = Перечисления.ТипыПодключаемогоОборудования.ВесыСПечатьюЭтикеток;
	Драйвер.ИмяДрайвера  = "ДрайверРБСВесыCПечатьюЭтикетокVenus";
	Драйвер.Наименование = НСтр("ru = 'РБС:Весы c печатью этикеток Venus'", ОбщегоНазначенияБПО.КодОсновногоЯзыка());
	Драйвер.ИдентификаторОбъекта = "Rbs1cVenusDriver";      
	Драйвер.ВерсияДрайвера = "3.0.2";    
	// -- Локализация
	// -- НеМобильноеПриложение     
	
КонецПроцедуры

// Подготовить данные операции перед выполнением команды.
// 
// Параметры:
//  ПараметрыПодключения - Структура - Параметры подключения.
//  Команда - Строка - Выполняемая команда.
//  ПараметрыОперации - Структура - Параметры операции.
// 
// Возвращаемое значение:
//  Структура.
Функция ПодготовитьДанныеОперации(ПараметрыПодключения, Команда, ПараметрыОперации) Экспорт
	
	Если Команда = "UploadGoods" Тогда
		
		Если ПараметрыОперации.ТаблицаТоваров.Количество() = 0 Тогда
			ОписаниеОшибки = НСтр("ru='Нет данных для выгрузки.'");
			ДанныеОперации = Новый Структура();
			ДанныеОперации.Вставить("Результат"  , Ложь);
			ДанныеОперации.Вставить("ТекстОшибки", ОписаниеОшибки);
			Возврат ДанныеОперации;
		КонецЕсли;
		ПолнаяВыгрузка = НЕ ПараметрыОперации.ЧастичнаяВыгрузка; 
		ПакетыДляВыгрузки = ПодготовитьПакетыДляЗагрузкиВВесыСПечатьюЭтикеток(ПараметрыОперации.ТаблицаТоваров, РазмерПакетаПоУмолчанию(), ПараметрыПодключения.РевизияИнтерфейса);
		ДанныеОперации = ПараметрыОперацииВесы();
		ДанныеОперации.ПакетыXML = ПакетыДляВыгрузки;
		ДанныеОперации.ПолнаяВыгрузка = ПолнаяВыгрузка;
		Возврат ДанныеОперации;
		
	ИначеЕсли Команда = "UploadProductImages" Тогда
		
		Если ПараметрыОперации.ТаблицаИзображений.Количество() = 0 Тогда
			ОписаниеОшибки = НСтр("ru='Нет данных для выгрузки.'");
			ДанныеОперации = Новый Структура();
			ДанныеОперации.Вставить("Результат"  , Ложь);
			ДанныеОперации.Вставить("ТекстОшибки", ОписаниеОшибки);
			Возврат ДанныеОперации;
		КонецЕсли;
		ПакетыДляВыгрузки = ПодготовитьПакетыДляЗагрузкиИзображенийВВесыСПечатьюЭтикеток(ПараметрыОперации.ТаблицаИзображений, РазмерПакетаПоУмолчанию(), ПараметрыПодключения.РевизияИнтерфейса);
		ДанныеОперации = ПараметрыОперацииВесы();
		ДанныеОперации.ПакетыXML = ПакетыДляВыгрузки;
		Возврат ДанныеОперации;
		
	КонецЕсли      
	
КонецФункции

// Обработать данные операции после выполнения команды.
// 
// Параметры:
//  ПараметрыПодключения - Структура - Параметры подключения.
//  Команда - Строка - Выполняемая команда.
//  РезультатВыполнения - Структура - результат выполнения операции.
//  ДанныеОперации - Структура - Параметры операции.
// 
Процедура ОбработатьДанныеОперации(ПараметрыПодключения, Команда, РезультатВыполнения, ДанныеОперации) Экспорт
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции   

// Заполнить структуру операции
// 
// Возвращаемое значение:
//  Структура - Параметры операции весы:
// * Результат - Булево.
// * ПакетыXML - Массив из ЧтениеXML.
// * ПолнаяВыгрузка - Булево.
// * ТекстОшибки - Строка.
Функция ПараметрыОперацииВесы()
	
	ПараметрыОперации = Новый Структура();
	ПараметрыОперации.Вставить("Результат", Истина);
	ПараметрыОперации.Вставить("ПакетыXML");
	ПараметрыОперации.Вставить("ПолнаяВыгрузка");
	ПараметрыОперации.Вставить("ТекстОшибки");
	Возврат ПараметрыОперации;
	
КонецФункции 

// Размер пакета в элементах передаваемой информации в драйвер.
//
// Возвращаемое значение:
//  Число
//
Функция РазмерПакетаПоУмолчанию()
	
	РазмерПакета = 10;
	Возврат РазмерПакета;
	
КонецФункции

// Сформировать таблицу товаров в XML структуре для весов с печатью этикеток.
// 
// Параметры:
//  ДанныеЗагрузки - Массив - Данные загрузки.           
//  РевизияИнтерфейса - Число - Ревизия интерфейса.
// 
// Возвращаемое значение:
//  ЗаписьXML - Сформировать таблицу товаров весы с печатью этикеток
Функция СформироватьТаблицуТоваровВесыСПечатьюЭтикеток(ДанныеЗагрузки, РевизияИнтерфейса = 0) 
	
	ЗаписьXML = Новый ЗаписьXML; 
	ЗаписьXML.УстановитьСтроку("UTF-8");
	ЗаписьXML.ЗаписатьОбъявлениеXML();
	
	ЗаписьXML.ЗаписатьНачалоЭлемента("Table");
	Для Каждого Позиция Из ДанныеЗагрузки  Цикл
		ЗаписьXML.ЗаписатьНачалоЭлемента("Record");   
		
		ВремНаименование = ?(Позиция.Свойство("Наименование"), Позиция.Наименование, ВремНаименование);
		Если Позиция.Свойство("НаименованиеПолное") И Не ПустаяСтрока(Позиция.НаименованиеПолное) Тогда
			ВремНаименование = Позиция.НаименованиеПолное;
		КонецЕсли;
		
		Цена = ?(Позиция.Свойство("Цена"), Позиция.Цена, 0);                       
		ОписаниеТовара = ?(Позиция.Свойство("ОписаниеТовара"), Позиция.ОписаниеТовара, Неопределено);  
		СрокХранения   = ?(Позиция.Свойство("СрокХранения")  , Позиция.СрокХранения, Неопределено);       
		ВесовойТовар   = ?(Позиция.Свойство("ВесовойТовар")  , Позиция.ВесовойТовар, Истина);     
		
		ЗаписьXML.ЗаписатьАтрибут("PLU"  , XMLСтрока(Число(Позиция.PLU)));
		ЗаписьXML.ЗаписатьАтрибут("Code" , XMLСтрока(Число(Позиция.Код)));
		ЗаписьXML.ЗаписатьАтрибут("Name" , ВремНаименование);
		ЗаписьXML.ЗаписатьАтрибут("Price", XMLСтрока(Цена));
		Если Не ПустаяСтрока(ОписаниеТовара) Тогда 
			ЗаписьXML.ЗаписатьАтрибут("Description", XMLСтрока(ОписаниеТовара));  
		КонецЕсли;  	
		Если Не ПустаяСтрока(СрокХранения) Тогда 
			ЗаписьXML.ЗаписатьАтрибут("ShelfLife", XMLСтрока(СрокХранения));  
		КонецЕсли;  	
		ЗаписьXML.ЗаписатьАтрибут("IsWeightGoods", XMLСтрока(ВесовойТовар));     
		
		Если РевизияИнтерфейса > 3007 Тогда // Версия стандарта 3.8 и выше
			
			ФорматЭтикетки = ?(Позиция.Свойство("ФорматЭтикетки"), Позиция.ФорматЭтикетки, Неопределено);     
			КнопкаТовара   = ?(Позиция.Свойство("КнопкаТовара"), Позиция.КнопкаТовара, Неопределено);
			Если Не ПустаяСтрока(ФорматЭтикетки) Тогда 
				ЗаписьXML.ЗаписатьАтрибут("LabelFormat", XMLСтрока(ФорматЭтикетки));     
			КонецЕсли;
			Если Не ПустаяСтрока(КнопкаТовара) Тогда 
				ЗаписьXML.ЗаписатьАтрибут("ButtonNumber", XMLСтрока(КнопкаТовара));     
			КонецЕсли;                                                                  
			
			Если Позиция.Свойство("ДополнительныеЦены") Тогда      
				ДополнительныеЦены = Позиция.ДополнительныеЦены;
				Цена1 = ?(ДополнительныеЦены.Свойство("Цена1"), ДополнительныеЦены.Цена1, 0);                      
				Цена2 = ?(ДополнительныеЦены.Свойство("Цена2"), ДополнительныеЦены.Цена2, 0);                      
				Цена3 = ?(ДополнительныеЦены.Свойство("Цена3"), ДополнительныеЦены.Цена3, 0);                      
				Цена4 = ?(ДополнительныеЦены.Свойство("Цена4"), ДополнительныеЦены.Цена4, 0);                      
				ЗаписьXML.ЗаписатьНачалоЭлемента("AdditionalPrices");     
				ЗаписьXML.ЗаписатьАтрибут("Price1", XMLСтрока(Цена1));     
				ЗаписьXML.ЗаписатьАтрибут("Price2", XMLСтрока(Цена2));     
				ЗаписьXML.ЗаписатьАтрибут("Price3", XMLСтрока(Цена3));     
				ЗаписьXML.ЗаписатьАтрибут("Price4", XMLСтрока(Цена4));     
				ЗаписьXML.ЗаписатьКонецЭлемента();
			КонецЕсли;     
			
		КонецЕсли;
		
		ЗаписьXML.ЗаписатьКонецЭлемента();
	КонецЦикла;
	ЗаписьXML.ЗаписатьКонецЭлемента();
		
	Возврат ЗаписьXML.Закрыть();
	
КонецФункции

// Сформировать таблицу изображений в XML структуре для весов с печатью этикеток.
// 
// Параметры:
//  ДанныеЗагрузки - Массив - Данные загрузки.           
//  РевизияИнтерфейса - Число - Ревизия интерфейса.
// 
// Возвращаемое значение:
//  ЗаписьXML - Сформировать таблицу товаров весы с печатью этикеток  
//
Функция СформироватьТаблицуИзображенийВесыСПечатьюЭтикеток(ДанныеЗагрузки, РевизияИнтерфейса = 0) 
	
	ЗаписьXML = Новый ЗаписьXML; 
	ЗаписьXML.УстановитьСтроку("UTF-8");
	ЗаписьXML.ЗаписатьОбъявлениеXML();
	
	ЗаписьXML.ЗаписатьНачалоЭлемента("Table");
	Для Каждого Позиция Из ДанныеЗагрузки  Цикл
		ЗаписьXML.ЗаписатьНачалоЭлемента("Record");   
		ЗаписьXML.ЗаписатьАтрибут("PLU"     , XMLСтрока(Число(Позиция.PLU)));
		ЗаписьXML.ЗаписатьАтрибут("Code"    , XMLСтрока(Число(Позиция.Код)));
		ЗаписьXML.ЗаписатьАтрибут("Picture" , XMLСтрока(Позиция.Изображение));
		ЗаписьXML.ЗаписатьКонецЭлемента();
	КонецЦикла;
	ЗаписьXML.ЗаписатьКонецЭлемента();
		
	Возврат ЗаписьXML.Закрыть();
	
КонецФункции

// Сформировать XML пакеты для загрузки в весы с печатью этикеток.   
// 
// Параметры:
//  ТаблицаВыгрузки - Массив - Данные для выгрузки.   
//  РазмерПакета - Число - Размер пакета.
//  РевизияИнтерфейса - Число - Ревизия интерфейса.
//
// Возвращаемое значение:
//  Массив из см. ОборудованиеВесовоеОборудование.СформироватьТаблицуТоваровВесыСПечатьюЭтикеток
//
Функция ПодготовитьПакетыДляЗагрузкиВВесыСПечатьюЭтикеток(ТаблицаВыгрузки, РазмерПакета, РевизияИнтерфейса = 0) 
	
	ПакетыДляВыгрузки = Новый Массив();
	МассивТоваров = Новый Массив;
	
	ЗаписьВПакете    = 0;
	ЗаписейВыгружено = 0;
	ЗаписейВсего     = ТаблицаВыгрузки.Количество();
	
	Для Каждого Позиция Из ТаблицаВыгрузки  Цикл
		
		Если ЗаписьВПакете = 0 Тогда
		    МассивТоваров.Очистить();
		КонецЕсли;
		МассивТоваров.Добавить(Позиция);
		ЗаписейВыгружено  = ЗаписейВыгружено + 1;
		ЗаписьВПакете = ЗаписьВПакете + 1;
		
		Если (ЗаписьВПакете = РазмерПакета) ИЛИ (ЗаписейВыгружено = ЗаписейВсего) Тогда  
			ДанныеДляВыгрузки = СформироватьТаблицуТоваровВесыСПечатьюЭтикеток(МассивТоваров, РевизияИнтерфейса);
			ПакетыДляВыгрузки.Добавить(ДанныеДляВыгрузки);
			ЗаписьВПакете = 0;
		КонецЕсли;
		
	КонецЦикла;
	
	Возврат ПакетыДляВыгрузки;
	
КонецФункции

// Сформировать XML пакеты для загрузки изображений в весы с печатью этикеток.   
// 
// Параметры:
//  ТаблицаИзображений - Массив - Данные для выгрузки.   
//
// Возвращаемое значение:
//  Массив из см. ОборудованиеВесовоеОборудование.СформироватьТаблицуТоваровВесыСПечатьюЭтикеток
//
Функция ПодготовитьПакетыДляЗагрузкиИзображенийВВесыСПечатьюЭтикеток(ТаблицаИзображений, РазмерПакета, РевизияИнтерфейса = 0) 
	
	ПакетыДляВыгрузки = Новый Массив();
	МассивИзображений = Новый Массив;
	
	ЗаписьВПакете    = 0;
	ЗаписейВыгружено = 0;
	ЗаписейВсего     = ТаблицаИзображений.Количество();
	
	Для Каждого Позиция Из ТаблицаИзображений Цикл
		
		Если ЗаписьВПакете = 0 Тогда
		    МассивИзображений.Очистить();
		КонецЕсли;
		МассивИзображений.Добавить(Позиция);
		ЗаписейВыгружено  = ЗаписейВыгружено + 1;
		ЗаписьВПакете = ЗаписьВПакете + 1;
		
		Если (ЗаписьВПакете = РазмерПакета) ИЛИ (ЗаписейВыгружено = ЗаписейВсего) Тогда  
			ДанныеДляВыгрузки = СформироватьТаблицуИзображенийВесыСПечатьюЭтикеток(МассивИзображений, РевизияИнтерфейса);
			ПакетыДляВыгрузки.Добавить(ДанныеДляВыгрузки);
			ЗаписьВПакете = 0;
		КонецЕсли;
		
	КонецЦикла;
	
	Возврат ПакетыДляВыгрузки;
	
КонецФункции

#КонецОбласти