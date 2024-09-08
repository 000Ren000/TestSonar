﻿#Область ПрограммныйИнтерфейс

// Определяет тип ЮрФизЛицо в форме помощника нового
// 
// Параметры:
// 	ЭтоКомпания - Число - признак, что партнер является компанией
// 	ВидКомпании - Число - вид компании
// Возвращаемое значение:
// 	ПеречислениеСсылка.ЮрФизЛицо - перечисление ЮрФизЛицо
//
Функция ТипЮрФизЛицаКонтрагента(ЭтоКомпания, ВидКомпании) Экспорт
	
	Если ЭтоКомпания = 0 Тогда
		Если ВидКомпании = 0 Или ВидКомпании = 3 Тогда
			Возврат ПредопределенноеЗначение("Перечисление.ЮрФизЛицо.ЮрЛицо");
		ИначеЕсли ВидКомпании = 1 Тогда
			Возврат ПредопределенноеЗначение("Перечисление.ЮрФизЛицо.ЮрЛицоНеРезидент");
		Иначе
			Возврат ПредопределенноеЗначение("Перечисление.ЮрФизЛицо.ИндивидуальныйПредприниматель"); 
		КонецЕсли;
	Иначе
		Возврат ПредопределенноеЗначение("Перечисление.ЮрФизЛицо.ФизЛицо");
	КонецЕсли;
	
КонецФункции

#КонецОбласти

#Область СлужебныйПрограммныйИнтерфейс

#Область УправлениеДоступностью

// Устанавливает доступность элементов формы элемента справочника Контрагенты.
//
// Параметры:
//	Форма - ФормаКлиентскогоПриложения - форма, для которой настраивается доступность.
//
Процедура УправлениеДоступностьюКонтрагент(Форма) Экспорт
	//++ Локализация
	РеквизитыКонтрагента = ПартнерыИКонтрагентыЛокализацияКлиентСервер.РеквизитыОбъектаКонтрагента(Форма);
	Если РеквизитыКонтрагента.ЭтоФормаПартнера Тогда
		ИсторияКПП = Форма.ИсторияКПП;
		ИсторияНаименований = Форма.ИсторияНаименований;
	Иначе
		ИсторияКПП = Форма.Объект.ИсторияКПП; 
		ИсторияНаименований = Форма.Объект.ИсторияНаименований;
	КонецЕсли;
	
	Если РеквизитыКонтрагента.ЭтоФормаПомощника Тогда
		ПартнерыИКонтрагентыЛокализацияКлиентСервер.УстановитьДоступностьКнопкиЗаполнитьПоИНН(Форма, 
			ПартнерыИКонтрагентыЛокализацияКлиентСервер.ТипЮрФизЛицаКонтрагента(Форма.ЭтоКомпания, Форма.ВидКомпании),
			Форма.ИНН,
			Форма.ВидКомпании = 3,
			Форма.НастройкиПодключенияКСервисуИППЗаданы,
			Ложь);
		
		УстановитьДоступностьКнопкиЗаполнитьПоСокрНаименованию_ПомощникНового(Форма);
	Иначе
	
		ПартнерыИКонтрагентыЛокализацияКлиентСервер.УстановитьВидимостьПредупрежденийГоловногоКонтрагента(Форма,
			РеквизитыКонтрагента.ОбособленноеПодразделение,
			РеквизитыКонтрагента.ГоловнойКонтрагент,
			РеквизитыКонтрагента.ИНН);
			
		ПартнерыИКонтрагентыЛокализацияКлиентСервер.УстановитьДоступностьКнопкиЗаполнитьПоИНН(Форма,
			РеквизитыКонтрагента.ЮрФизЛицо,
			РеквизитыКонтрагента.ИНН,
			РеквизитыКонтрагента.ОбособленноеПодразделение,
			Форма.НастройкиПодключенияКСервисуИППЗаданы,
			Ложь);
			
		ПартнерыИКонтрагентыЛокализацияКлиентСервер.УстановитьДоступностьКнопкиЗаполнитьПоСокрНаименованию(Форма,
			РеквизитыКонтрагента.ЮрФизЛицо,
			Форма.Объект.НаименованиеПолное,
			РеквизитыКонтрагента.ОбособленноеПодразделение,
			Форма.НастройкиПодключенияКСервисуИППЗаданы);
	
		ПартнерыИКонтрагентыЛокализацияКлиентСервер.ОбновитьСтрокиИсторииКПП(ИсторияКПП, 
			Форма.ПереходКИсторииКПП,
			Форма.ЦветГиперссылки);
			
		ПартнерыИКонтрагентыЛокализацияКлиентСервер.ОбновитьСтрокиИсторииНаименований(
			ИсторияНаименований,
			Форма.ПереходКИсторииНаименования,
			Форма.ЦветГиперссылки);
	
		Форма.Элементы.КПП.ТолькоПросмотр = ИсторияКПП.Количество() > 1;
			
		Форма.Элементы.НДСПоСтавкам4и2.Видимость = РеквизитыКонтрагента.НДСПоСтавкам4и2;
	
	КонецЕсли;
	//-- Локализация
КонецПроцедуры

// Устанавливает доступность элементов формы элемента справочника Контрагенты.
//
// Параметры:
//	Форма - ФормаКлиентскогоПриложения - форма, для которой настраивается доступность.
//
Процедура УправлениеДоступностьюГоловнойКонтрагент(Форма) Экспорт
	//++ Локализация
	Элементы = Форма.Элементы;
		
	ТекстПредупреждения = ПартнерыИКонтрагентыЛокализацияКлиентСервер.ТекстПредупрежденияГоловногоКонтрагента(Элементы.ГоловнойКонтрагент.СписокВыбора, Форма.ИНН);
	ОбщегоНазначенияУТКлиентСервер.УстановитьСвойствоЭлементаФормы(
		Элементы, "ПредупреждениеГоловнойКонтрагент", "Заголовок", ТекстПредупреждения);
	
	МассивЭлементов = Новый Массив;
	МассивЭлементов.Добавить("КартинкаПредупреждениеГоловнойКонтрагент");
	МассивЭлементов.Добавить("ПредупреждениеГоловнойКонтрагент");
	
	ЕстьПредупреждение = Не ПустаяСтрока(ТекстПредупреждения);
	
	Если Форма.ВыбратьГоловногоКонтрагента = 0 И ЕстьПредупреждение Тогда
		 Форма.ВыбратьГоловногоКонтрагента = 1;
	КонецЕсли;
	
	ОбщегоНазначенияУТКлиентСервер.УстановитьСвойствоЭлементовФормы(
		Элементы, МассивЭлементов, "Видимость", ЕстьПредупреждение);
	
	ОбщегоНазначенияУТКлиентСервер.УстановитьСвойствоЭлементаФормы(
		Элементы, "ВыбратьГоловногоКонтрагента", "Доступность", Не ЕстьПредупреждение);
	
	ОбщегоНазначенияУТКлиентСервер.УстановитьСвойствоЭлементаФормы(
		Элементы, "ГруппаГоловнойКонтрагент", "Доступность", Не ЕстьПредупреждение И Форма.ВыбратьГоловногоКонтрагента = 0);
	
	ОбщегоНазначенияУТКлиентСервер.УстановитьСвойствоЭлементаФормы(
		Элементы, "ГруппаДанныеГоловногоКонтрагента", "Доступность",  Форма.ВыбратьГоловногоКонтрагента = 1);
		
	ОбщегоНазначенияУТКлиентСервер.УстановитьСвойствоЭлементаФормы(
		Элементы, "КППГоловногоКонтрагента", "Доступность",  Форма.ВыбратьГоловногоКонтрагента = 1 И ЗначениеЗаполнено(Форма.ИНН));
		
	ПартнерыИКонтрагентыЛокализацияКлиентСервер.УстановитьДоступностьКнопкиЗаполнитьПоИНН(Форма, 
		ПредопределенноеЗначение("Перечисление.ЮрФизЛицо.ЮрЛицо"),
		Форма.ИНН,
		Ложь,
		Форма.НастройкиПодключенияКСервисуИППЗаданы,
		Ложь,
		"ГоловнойКонтрагент");
		
	УстановитьДоступностьКнопкиЗаполнитьПоСокрНаименованию_ПомощникНового(Форма);
	//-- Локализация
КонецПроцедуры

// Устанавливает доступность и видимость юридическим реквизитам: ИНН, КПП, КодПоОКПО, ГоловнойКонтрагент
// в зависимости от вида контрагента.
//
// Параметры:
//  Форма - ФормаКлиентскогоПриложения - форма, для которой выполняются действия.
//
Процедура УправлениеЭлементамиЮридическихРеквизитов(Форма) Экспорт
	
	//++ Локализация
	
	Элементы = Форма.Элементы;
	РеквизитыКонтрагента = ПартнерыИКонтрагентыЛокализацияКлиентСервер.РеквизитыОбъектаКонтрагента(Форма);
	ЮрФизЛицо = РеквизитыКонтрагента.ЮрФизЛицо;

	ЭтоЮрЛицо             = (ЮрФизЛицо = ПредопределенноеЗначение("Перечисление.ЮрФизЛицо.ЮрЛицо"));
	ЭтоФизЛицо            = (ЮрФизЛицо = ПредопределенноеЗначение("Перечисление.ЮрФизЛицо.ФизЛицо"));
	ЭтоИндПредприниматель = (ЮрФизЛицо = ПредопределенноеЗначение("Перечисление.ЮрФизЛицо.ИндивидуальныйПредприниматель"));
	ЭтоНеРезидент         = (ЮрФизЛицо = ПредопределенноеЗначение("Перечисление.ЮрФизЛицо.ЮрЛицоНеРезидент"));
	
	Если ЗначениеНастроекКлиентСерверПовтИсп.ОсновнаяСтрана() = ПредопределенноеЗначение("Справочник.СтраныМира.Россия") Тогда
		
		// Страна регистрация видна только в том случае, когда контрагент не является резидентом РФ. 
		// В противном случае - и для физ лиц и для ИП и для юр лиц страна регистрации всегда Россия.
		Элементы.ГруппаСтраницыДанныхРегистрацииКонтрагента.ТекущаяСтраница = 
			?(ЭтоНеРезидент, 
			Элементы.ГруппаСтраницаИностраннойРегистрации, Элементы.ЛокализацияГруппаСтраницаРоссийскогоКонтрагента);
			
		Если Не ЭтоНеРезидент Тогда
			Если ЭтоФизЛицо
				Или ЭтоИндПредприниматель Тогда
				
				Элементы.СтраницаИННФизЛицо.Видимость	= Истина;
				Элементы.СтраницаИННЮрЛицо.Видимость	= Ложь;
				
				Если ЭтоИндПредприниматель Тогда
					Элементы.СтраницыОГРН.ТекущаяСтраница = Элементы.СтраницаОГРНФизЛицо;
				КонецЕсли
				
			Иначе
				Элементы.СтраницаИННФизЛицо.Видимость	= Ложь;
				Элементы.СтраницаИННЮрЛицо.Видимость	= Истина;
				
				Элементы.СтраницыОГРН.ТекущаяСтраница = Элементы.СтраницаОГРНЮрЛицо;
			КонецЕсли;
			
		КонецЕсли;
		
		МассивЭлементов = Новый Массив;
		МассивЭлементов.Добавить("ИНН");
		МассивЭлементов.Добавить("КПП");
		МассивЭлементов.Добавить("ПереходКИсторииКПП");
		МассивЭлементов.Добавить("ЗаполнитьПоНаименованиюПоДаннымЕдиныхГосРеестров");
		
		ОбщегоНазначенияУТКлиентСервер.УстановитьСвойствоЭлементовФормы(Элементы, МассивЭлементов, "Доступность", ЭтоЮрЛицо);
		
		МассивЭлементов = Новый Массив;
		МассивЭлементов.Добавить("КодПоОКПО");
		МассивЭлементов.Добавить("ОГРН");
		МассивЭлементов.Добавить("ОГРНИП");
		
		ЗначениеДоступности = ЭтоЮрЛицо
								Или ЭтоИндПредприниматель;
		
		ОбщегоНазначенияУТКлиентСервер.УстановитьСвойствоЭлементовФормы(
			Элементы,
			МассивЭлементов,
			"Видимость",
			ЗначениеДоступности);
		
		МассивЭлементов = Новый Массив;
		МассивЭлементов.Добавить("ГоловнойКонтрагент");
		МассивЭлементов.Добавить("ЗаполнитьГоловногоКонтрагента");
		
		ОбщегоНазначенияУТКлиентСервер.УстановитьСвойствоЭлементовФормы(
			Элементы, МассивЭлементов, "Видимость", РеквизитыКонтрагента.ОбособленноеПодразделение);
		
	Иначе
		МассивЭлементов = Новый Массив;
		МассивЭлементов.Добавить("КПП");
		
		МассивЭлементов.Добавить("ПереходКИсторииКПП");
		МассивЭлементов.Добавить("ЗаполнитьПоНаименованиюПоДаннымЕдиныхГосРеестров");
		
		МассивЭлементов.Добавить("КодПоОКПО");
		МассивЭлементов.Добавить("ОГРН");
		МассивЭлементов.Добавить("ОГРНИП");
		
		МассивЭлементов.Добавить("ГоловнойКонтрагент");
		МассивЭлементов.Добавить("ЗаполнитьГоловногоКонтрагента");
		ОбщегоНазначенияУТКлиентСервер.УстановитьСвойствоЭлементовФормы(Элементы, МассивЭлементов, "Видимость", ЛОЖЬ);
		
		Элементы.ГруппаСтраницыДанныхРегистрацииКонтрагента.ТекущаяСтраница = Форма.Элементы.ГруппаСтраницаИностраннойРегистрации;
	КонецЕсли;
	//-- Локализация
КонецПроцедуры

//++ Локализация

// Устанавливает доступность кнопки заполнения КПП по ИНН и виду контрагента.
// Кнопка недоступна, если не заполнен ИНН.
//
// Параметры:
//  Форма                                 - ФормаКлиентскогоПриложения - форма, для которой выполняются действия.
//  ЮрФизЛицо                             - Перечисление.ЮрФизЛицо - вид контрагента.
//  ИНН                                   - Строка - значение ИНН контрагента.
//  ЭтоОбособленноеПодразделение          - Булево - признак того, что этого обособленное подразделение.
//  НастройкиПодключенияКСервисуИППЗаданы - Булево - признак того, что настройки к сервису интернет.
//  КнопкаНедоступнаБезусловно            - Булево - признак того, что кнопка не доступна безусловно.
//  ПостфиксИмениЭлементаФормы            - Строка - добавляется к стандартному имени обрабатываемого элемента формы.
//
Процедура УстановитьДоступностьКнопкиЗаполнитьПоИНН(Форма, 
	                                                ЮрФизЛицо,
	                                                ИНН,
	                                                ЭтоОбособленноеПодразделение,
	                                                НастройкиПодключенияКСервисуИППЗаданы,
	                                                КнопкаНедоступнаБезусловно = Ложь,
	                                                ПостфиксИмениЭлементаФормы = "") Экспорт
	
	ЭтоЮрЛицо = ОбщегоНазначенияУТКлиентСервер.ЭтоЮрЛицо(ЮрФизЛицо);
	
	ОбщегоНазначенияУТКлиентСервер.УстановитьСвойствоЭлементаФормы(
		Форма.Элементы,
		"ЗаполнитьПоИНН" + ПостфиксИмениЭлементаФормы,
		"Доступность",
		(Не КнопкаНедоступнаБезусловно) 
		  И НастройкиПодключенияКСервисуИППЗаданы 
		  И ЭтоЮрЛицо И Не ПустаяСтрока(ИНН) 
		  И Не ЭтоОбособленноеПодразделение
		  И Форма.ПравоИзмененияОбъекта);
		
	ОбщегоНазначенияУТКлиентСервер.УстановитьСвойствоЭлементаФормы(
		Форма.Элементы,
		"ЗаполнитьПоИННФизЛицо",
		"Доступность",
		(Не КнопкаНедоступнаБезусловно) 
		  И НастройкиПодключенияКСервисуИППЗаданы 
		  И ЮрФизЛицо = ПредопределенноеЗначение("Перечисление.ЮрФизЛицо.ИндивидуальныйПредприниматель") 
		  И Не ПустаяСтрока(ИНН)
		  И Форма.ПравоИзмененияОбъекта);
		
КонецПроцедуры

// Устанавливает доступность кнопки заполнения по скор наименованию.
//
// Параметры:
//  Форма - ФормаКлиентскогоПриложения - форма, для которой выполняются действия.
Процедура УстановитьДоступностьКнопкиЗаполнитьПоСокрНаименованию_ПомощникНового(Форма) Экспорт
	Если Форма.Элементы.СтраницыПомощника.ТекущаяСтраница = Форма.Элементы.СтраницаПервичнаяИнформация Тогда
		
		ЮрФизЛицо = ПартнерыИКонтрагентыЛокализацияКлиентСервер.ТипЮрФизЛицаКонтрагента(Форма.ЭтоКомпания, Форма.ВидКомпании);
		ЭтоОбособленноеПодразделение = (Форма.ВидКомпании = 3);
		СтрокаНаименование = Форма.ПолноеЮридическоеНаименование;
		Если Форма.ИспользуютсяТолькоПартнеры Тогда
			ИмяЭлементаФормы = "ЗаполнитьПоНаименованиюПоДаннымЕдиныхГосРеестровТолькоПартнеры";
		Иначе
			ИмяЭлементаФормы = "ЗаполнитьПоНаименованиюПоДаннымЕдиныхГосРеестров";
		КонецЕсли;
		
	Иначе
		
		ИмяЭлементаФормы = "ЗаполнитьПоНаименованиюПоДаннымЕдиныхГосРеестровГоловнойКонтрагент";
		ЮрФизЛицо = ПредопределенноеЗначение("Перечисление.ЮрФизЛицо.ЮрЛицо");
		СтрокаНаименование = Форма.ПолноеНаименованиеГоловногоКонтрагента;
		ЭтоОбособленноеПодразделение = Ложь;
		
	КонецЕсли;
	
	ПартнерыИКонтрагентыЛокализацияКлиентСервер.УстановитьДоступностьКнопкиЗаполнитьПоСокрНаименованию(Форма,
		ЮрФизЛицо,
		СтрокаНаименование,
		ЭтоОбособленноеПодразделение,
		Форма.НастройкиПодключенияКСервисуИППЗаданы,
		ИмяЭлементаФормы);	
КонецПроцедуры
	
// Устанавливает доступность кнопки заполнения реквизитов контрагента по наименованию.
// Кнопка доступна если контрагент юр.лицо и есть подключения к интернет-поддержке.
//
// Параметры:
//  Форма                                 - ФормаКлиентскогоПриложения - форма, для которой выполняются действия.
//  ЮрФизЛицо                             - Перечисление.ЮрФизЛицо - вид контрагента.
//  СокрЮрНаименование                    - Строка - наименование контрагента.
//  ЭтоОбособленноеПодразделение          - Булево - признак того, что этого обособленное подразделение.
//  НастройкиПодключенияКСервисуИППЗаданы - Булево - признак того, что настройки к сервису интернет
//  ИмяЭлементаФормы                      - Строка - имя элемента формы, если отлично от стандартного.
//
Процедура УстановитьДоступностьКнопкиЗаполнитьПоСокрНаименованию(Форма, 
	                                                             ЮрФизЛицо,
	                                                             СокрЮрНаименование,
	                                                             ЭтоОбособленноеПодразделение,
	                                                             НастройкиПодключенияКСервисуИППЗаданы,
	                                                             ИмяЭлементаФормы = "ЗаполнитьПоНаименованиюПоДаннымЕдиныхГосРеестров") Экспорт
	
	ОбщегоНазначенияУТКлиентСервер.УстановитьСвойствоЭлементаФормы(
		Форма.Элементы,
		ИмяЭлементаФормы,
		"Доступность",
		 НастройкиПодключенияКСервисуИППЗаданы 
		  И ЮрФизЛицо = ПредопределенноеЗначение("Перечисление.ЮрФизЛицо.ЮрЛицо") 
		  И Не ПустаяСтрока(СокрЮрНаименование) 
		  И Не ЭтоОбособленноеПодразделение
		  И Форма.ПравоИзмененияОбъекта);
	
КонецПроцедуры

//-- Локализация

#КонецОбласти

#Область ЗаполнениеГоловногоКонтрагента

// Дополнить параметры формы создания головного контрагента
//
// Параметры:
//  ПараметрыСоздания	 - Структура - дополняемая структура параметров
//  ИсточникДанных		 - ДанныеФормыСтруктура, Структура - данные выбранной строки
//
Процедура ДополнитьПараметрыЗаполнитьГоловногоКонтрагента(ПараметрыСоздания, ИсточникДанных = Неопределено) Экспорт
	//++ Локализация
	ПараметрыСоздания.Вставить("ИНН", "");
	Если ИсточникДанных <> Неопределено Тогда
		ПараметрыСоздания.ИНН = ИсточникДанных.ИНН;
	КонецЕсли;
	//-- Локализация	
КонецПроцедуры

#КонецОбласти

#Область ПрочиеСлужебныеМетоды

Процедура ОбновитьСтрокиИсторииНаименований(Знач ИсторияНаименований, ПереходКИсторииНаименования, ЦветГиперссылки) Экспорт
	
	ТекстКомандыИсторииНаименования = "";
	Если ИсторияНаименований.Количество() = 0 Тогда
		ТекстКомандыИсторииНаименования = НСтр("ru = 'установлено изначально'");
	Иначе
		ИсторияНаименований.Сортировать("Период Убыв");
		ТекстКомандыИсторииНаименования = СтрШаблон(НСтр("ru = 'установлено с %1'"), Формат(ИсторияНаименований[0].Период,"ДЛФ=D"));
	КонецЕсли;
	
	ПереходКИсторииНаименования = Новый ФорматированнаяСтрока(ТекстКомандыИсторииНаименования,,ЦветГиперссылки,, "ИсторияНаименований");

КонецПроцедуры

//++ Локализация

// Реквизиты объекта контрагента.
// 
// Параметры:
//  Форма - ФормаКлиентскогоПриложения - форма для которой получаются реквизиты контрагента
// 
// Возвращаемое значение:
//  Структура - содержит:
//	  * ЭтоФормаПомощника - Булево - Истина, если это форма помощника создания нового партнера
//
Функция РеквизитыОбъектаКонтрагента(Форма) Экспорт

	СтруктураРеквизитов = Новый Структура;
	СтруктураРеквизитов.Вставить("ЭтоФормаПомощника", СтрНайти(Форма.ИмяФормы, "ПомощникНового") > 0);
	СтруктураРеквизитов.Вставить("ЭтоФормаПартнера", Не СтрНайти(Форма.ИмяФормы, "Контрагенты") > 0);
	СтруктураРеквизитов.Вставить("ЭтоФормаКонтрагента", СтрНайти(Форма.ИмяФормы, "Контрагенты") > 0);
	
	Если СтруктураРеквизитов.ЭтоФормаПомощника Тогда
		СтруктураРеквизитов.Вставить("ЮрФизЛицо", ТипЮрФизЛицаКонтрагента(Форма.ЭтоКомпания, Форма.ВидКомпании));
		СтруктураРеквизитов.Вставить("ИНН", Форма.ИНН);
		СтруктураРеквизитов.Вставить("ПутьКИНН", "ИНН");
		СтруктураРеквизитов.Вставить("КПП", Форма.КПП);
		СтруктураРеквизитов.Вставить("ПутьКПП", "КПП");
		СтруктураРеквизитов.Вставить("КодПоОКПО", Форма.КодПоОКПО);
		СтруктураРеквизитов.Вставить("ПутьКодПоОКПО", "КодПоОКПО");
		СтруктураРеквизитов.Вставить("РегистрационныйНомер", Форма.РегистрационныйНомер);
		СтруктураРеквизитов.Вставить("ПутьРегистрационныйНомер", "РегистрационныйНомер");
		СтруктураРеквизитов.Вставить("ОбособленноеПодразделение", Форма.ВидКомпании = 3);
		СтруктураРеквизитов.Вставить("ГоловнойКонтрагент", Форма.ГоловнойКонтрагент);
		СтруктураРеквизитов.Вставить("НДСПоСтавкам4и2", Ложь);
	ИначеЕсли СтруктураРеквизитов.ЭтоФормаПартнера Тогда
		СтруктураРеквизитов.Вставить("ЮрФизЛицо", Форма.ЮрФизЛицо);
		СтруктураРеквизитов.Вставить("ИНН", Форма.ИНН);
		СтруктураРеквизитов.Вставить("ПутьКИНН", "ИНН");
		СтруктураРеквизитов.Вставить("КПП", Форма.КПП);
		СтруктураРеквизитов.Вставить("ПутьКПП", "КПП");
		СтруктураРеквизитов.Вставить("КодПоОКПО", Форма.КодПоОКПО);
		СтруктураРеквизитов.Вставить("РегистрационныйНомер", Форма.РегистрационныйНомер);
		СтруктураРеквизитов.Вставить("ПутьРегистрационныйНомер", "РегистрационныйНомер");
		СтруктураРеквизитов.Вставить("ПутьКодПоОКПО", "КодПоОКПО");
		СтруктураРеквизитов.Вставить("ОбособленноеПодразделение", Форма.ОбособленноеПодразделение);
		СтруктураРеквизитов.Вставить("ГоловнойКонтрагент", Форма.ГоловнойКонтрагент);
		СтруктураРеквизитов.Вставить("НДСПоСтавкам4и2", Форма.НДСПоСтавкам4и2);
	Иначе
		Объект = Форма.Объект;
		СтруктураРеквизитов.Вставить("ЮрФизЛицо", Объект.ЮрФизЛицо);
		СтруктураРеквизитов.Вставить("ИНН", Объект.ИНН);
		СтруктураРеквизитов.Вставить("ПутьКИНН", "Объект.ИНН");
		СтруктураРеквизитов.Вставить("КПП", Объект.КПП);
		СтруктураРеквизитов.Вставить("ПутьКПП", "Объект.КПП");
		СтруктураРеквизитов.Вставить("КодПоОКПО", Объект.КодПоОКПО);
		СтруктураРеквизитов.Вставить("ПутьКодПоОКПО", "Объект.КодПоОКПО");
		СтруктураРеквизитов.Вставить("РегистрационныйНомер", Объект.РегистрационныйНомер);
		СтруктураРеквизитов.Вставить("ПутьРегистрационныйНомер", "Объект.РегистрационныйНомер");
		СтруктураРеквизитов.Вставить("ОбособленноеПодразделение", Объект.ОбособленноеПодразделение);
		СтруктураРеквизитов.Вставить("ГоловнойКонтрагент", Объект.ГоловнойКонтрагент);
		СтруктураРеквизитов.Вставить("НДСПоСтавкам4и2", Объект.НДСПоСтавкам4и2);
	КонецЕсли;
	
	Возврат СтруктураРеквизитов
	
КонецФункции

Процедура УстановитьРеквизитыПроверкиКонтрагента(Форма) Экспорт
	
	ЮрФизЛицо = Ложь;
	РеквизитыКонтрагента = ПартнерыИКонтрагентыЛокализацияКлиентСервер.РеквизитыОбъектаКонтрагента(Форма);
	ЮрФизЛицо = РеквизитыКонтрагента.ЮрФизЛицо;

	Если Форма.РеквизитыПроверкиКонтрагентов.ПроверкаИспользуется Тогда
		Форма.РеквизитыПроверкиКонтрагентов.ЮрФизЛицо                 = ЮрФизЛицо;
		Форма.РеквизитыПроверкиКонтрагентов.ЭтоЮридическоеЛицо        = (ЮрФизЛицо = ПредопределенноеЗначение("Перечисление.ЮрФизЛицо.ЮрЛицо") 
		                                                            Или  ЮрФизЛицо = ПредопределенноеЗначение("Перечисление.ЮрФизЛицо.ЮрЛицоНеРезидент"));
		// Здесь как иностранных контрагентов указываем всех контрагентов, которые не подлежат проверке.
		Форма.РеквизитыПроверкиКонтрагентов.ЭтоИностранныйКонтрагент  =ЮрФизЛицо = ПредопределенноеЗначение("Перечисление.ЮрФизЛицо.ЮрЛицоНеРезидент")
		                                                                Или ЮрФизЛицо = ПредопределенноеЗначение("Перечисление.ЮрФизЛицо.ФизЛицо");
	КонецЕсли;

КонецПроцедуры

Процедура ОбновитьСтрокиИсторииКПП(Знач ИсторияКПП, ПереходКИсторииКПП, ЦветГиперссылки) Экспорт

	ТекстКомандыИсторииКПП = "";
	Если ИсторияКПП.Количество() = 0 Тогда
		ТекстКомандыИсторииКПП = НСтр("ru = 'установлен изначально'");
	Иначе
		ИсторияКПП.Сортировать("Период Убыв");
		ТекстКомандыИсторииКПП = СтрШаблон(НСтр("ru = 'установлен с %1'"), Формат(ИсторияКПП[0].Период,"ДЛФ=D"));
	КонецЕсли;
	
	ПереходКИсторииКПП = Новый ФорматированнаяСтрока(ТекстКомандыИсторииКПП,,ЦветГиперссылки,, "ИсторияКПП");
	
КонецПроцедуры

Функция ЭтоИНН(СтрокаИНН) Экспорт
	Возврат ЗначениеЗаполнено(СтрокаИНН)
		И ТипЗнч(СтрокаИНН) = Тип("Строка")
		И (СтрДлина(СтрокаИНН) = 10 ИЛИ СтрДлина(СтрокаИНН) = 12)
		И СтроковыеФункцииКлиентСервер.ТолькоЦифрыВСтроке(СтрокаИНН);
КонецФункции

// Проверяет необходимые условия для подключения к сервису получения данных контрагентов по ИНН.
//
// Параметры:
//  ИННЗаполненКорректно                   - Булево - признак того, что ИНН, по которому будут получены данные корректен.
//  НастройкиПодключенияКСервисуИППЗаданы  - Булево - признак того, что в настройках программы заданы настройки
//        подключения к сервису. интернет поддержки пользователей.
//  ЭтоЮрлицо                             - Булево - признак того, что контрагент является юридическим лицом.
//  ЭтоИндивидуальныйПредприниматель      - Булево - признак того, что контрагент является индивидуальным предпринимателем.
//  ОбособленноеПодразделение             - Булево - признак того, что контрагент является обособленным подразделением.
//
// Возвращаемое значение:
//   Булево   - Истина, если заполнение возможно, Ложь в обратно случае.
//
Функция ЗаполнениеРеквизитовПоДаннымИННВозможно(ИННЗаполненКорректно,
	                                            НастройкиПодключенияКСервисуИППЗаданы,
	                                            ЭтоЮрлицо,
	                                            ЭтоИндивидуальныйПредприниматель,
	                                            ОбособленноеПодразделение) Экспорт
	
	Возврат ИННЗаполненКорректно И НастройкиПодключенияКСервисуИППЗаданы
	        И (ЭтоЮрлицо ИЛИ ЭтоИндивидуальныйПредприниматель) И Не ОбособленноеПодразделение; 
	
КонецФункции

// Устанавливает видимость элементов предупреждения, что не заполнен головной контрагент.
//
// Параметры:
//  Форма - ФормаКлиентскогоПриложения - форма, для которой выполняются действия.
//  ОбособленноеПодразделение - Булево - признак обособленного контрагента.
//  ГоловнойКонтрагент - Справочник.Контрагенты - значение головного контрагент.
//
Процедура УстановитьВидимостьПредупрежденийГоловногоКонтрагента(Форма, Знач ОбособленноеПодразделение, Знач ГоловнойКонтрагент, Знач ИНН) Экспорт
	
	ВидимостьЭлементов = Ложь;
	Если ОбособленноеПодразделение Тогда
		ВидимостьЭлементов = Не ЗначениеЗаполнено(ГоловнойКонтрагент);
	КонецЕсли;
	
	МассивЭлементов = Новый Массив;
	МассивЭлементов.Добавить("ЗаполнитьГоловногоКонтрагента");
	МассивЭлементов.Добавить("КартинкаПредупреждениеГоловнойКонтрагент");
	МассивЭлементов.Добавить("ПредупреждениеГоловнойКонтрагент");
	
	ОбщегоНазначенияУТКлиентСервер.УстановитьСвойствоЭлементовФормы(
		Форма.Элементы, МассивЭлементов, "Видимость", ВидимостьЭлементов);
		
	ОбщегоНазначенияУТКлиентСервер.УстановитьСвойствоЭлементаФормы(
		Форма.Элементы, "ЗаполнитьГоловногоКонтрагента", "Доступность", Не ПустаяСтрока(ИНН)); 
	
КонецПроцедуры

// Формирует текст предупреждения головного контрагента
// 
// Параметры:
// 	СписокВыбораГоловногоКонтрагента - СписокЗначений - список выбора
// 	ИНН - Строка - инн контрагента
// Возвращаемое значение:
// 	Строка - текст предупреждения
//
Функция ТекстПредупрежденияГоловногоКонтрагента(СписокВыбораГоловногоКонтрагента, ИНН) Экспорт
	
	ТекстПредупреждения = "";
	Если НЕ ЗначениеЗаполнено(ИНН) Тогда
		ТекстПредупреждения = НСтр("ru='Не задан ИНН: невозможно установить головного контрагента.'");
	ИначеЕсли СписокВыбораГоловногоКонтрагента.Количество() = 0 Тогда
		ТекстПредупреждения = НСтр("ru='Не найдены головные контрагенты по указанному ИНН.'")
	КонецЕсли;
	
	Возврат ТекстПредупреждения;
	
КонецФункции

//-- Локализация

#КонецОбласти

#КонецОбласти
