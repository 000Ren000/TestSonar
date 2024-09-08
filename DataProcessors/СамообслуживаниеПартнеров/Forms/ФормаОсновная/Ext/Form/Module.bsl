﻿
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если Параметры.Свойство("АвтоТест") Тогда // Возврат при получении формы для анализа.
		Возврат;
	КонецЕсли;
	
	Если Не ПользователиКлиентСервер.ЭтоСеансВнешнегоПользователя() Тогда
		Отказ = Истина;
		Возврат;
	КонецЕсли;

	ЗаполнитьЗначенияСвойств(ЭтотОбъект, ПартнерыИКонтрагентыВызовСервера.ДанныеАвторизовавшегосяВнешнегоПользователя());
	
	Если Партнер = Неопределено ИЛИ Партнер.Пустая() Тогда
		Отказ = Истина;
		Возврат;
	КонецЕсли;
	
	ЗаполнитьПриветственнуюИнформацию();
	
КонецПроцедуры

&НаКлиенте
Процедура ОбработкаОповещения(ИмяСобытия, Параметр, Источник)
	
	Если (ИмяСобытия = "Запись_ЗаказКлиента" Или ИмяСобытия = "Запись_Партнеры")
		И Параметр.Свойство("Партнер")
		И Параметр.Партнер = Партнер Тогда
		
		ЗаполнитьПриветственнуюИнформацию();
		
	ИначеЕсли ИмяСобытия = "Запись_КонтактныеЛицаПартнеров" 
		И Параметр.Свойство("Владелец")
		И Параметр.Владелец = Партнер Тогда
		
		ЗаполнитьПриветственнуюИнформацию();
		
	ИначеЕсли ИмяСобытия = "Запись_КорзинаПокупателя" И Параметр.Свойство("ОбъектАвторизации") Тогда
		
		Если ТипЗнч(Параметр.ОбъектАвторизации) = Тип("СправочникСсылка.Партнеры") 
			И Параметр.ОбъектАвторизации = Партнер Тогда
			
			ЗаполнитьПриветственнуюИнформацию();
			
		ИначеЕсли ТипЗнч(Параметр.ОбъектАвторизации) = Тип("СправочникСсылка.КонтактныеЛицаПартнеров") 
			И Параметр.ОбъектАвторизации = КонтактноеЛицо Тогда
			
			ЗаполнитьПриветственнуюИнформацию();
			
		КонецЕсли;
		
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура ПриветственнаяИнформацияПриНажатии(Элемент, ДанныеСобытия, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	Если СтрЧислоВхождений(ДанныеСобытия.Href,"cart") > 0 Тогда
		ОткрытьФорму("Обработка.СамообслуживаниеПартнеров.Форма.КорзинаПокупателя",
		,
		ПолучитьОкна()[0],
		,
		ОкноПриложения());
	ИначеЕсли  СтрЧислоВхождений(ДанныеСобытия.Href,"orders") > 0 Тогда
		
		ОткрытьФорму("Документ.ЗаказКлиента.Форма.ФормаСпискаСамообслуживание",
		,
		ПолучитьОкна()[0],
		,
		ОкноПриложения());
		
	ИначеЕсли  СтрЧислоВхождений(ДанныеСобытия.Href,"Change_information_partner") > 0 Тогда
		
		ОткрытьФорму("Обработка.СамообслуживаниеПартнеров.Форма.ИзменениеКонтактнойИнформации",
		,
		ПолучитьОкна()[0]);
		
	ИначеЕсли  СтрЧислоВхождений(ДанныеСобытия.Href,"List_of_polls") > 0 Тогда
		
		ОткрытьФорму("Обработка.ДоступныеАнкеты.Форма.Форма",
		,
		ПолучитьОкна()[0],
		,
		ОкноПриложения());
		
	ИначеЕсли  СтрЧислоВхождений(ДанныеСобытия.Href,"Change_information_contact") > 0 Тогда
		
		ОткрытьФорму("Справочник.КонтактныеЛицаПартнеров.Форма.ФормаЭлемента",
		Новый Структура("Ключ",КонтактноеЛицо),
		ПолучитьОкна()[0]);
		
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаКлиенте
Функция ОкноПриложения()
	
	Возврат ?(КлиентскоеПриложение.ТекущийВариантИнтерфейса() = ВариантИнтерфейсаКлиентскогоПриложения.Версия8_2,ПолучитьОкна()[0], Неопределено);
	
КонецФункции

&НаСервере
Процедура ЗаполнитьПриветственнуюИнформацию()
	
	Если АвторизованПартнер Тогда
		ПриветственнаяИнформация = Обработки.СамообслуживаниеПартнеров.ПолучитьМакет("ГлавнаяСтраница").ПолучитьТекст();
	Иначе
		ПриветственнаяИнформация = Обработки.СамообслуживаниеПартнеров.ПолучитьМакет("ГлавнаяСтраницаКонтактноеЛицо").ПолучитьТекст();
	КонецЕсли;
	
	СамообслуживаниеСервер.УстановитьЦветФонаИнформацииНTML(ПриветственнаяИнформация);
	
	ТекущийНомерЗапроса = 0;
	СоответствиеИнформацииНомеровЗапроса = Новый Соответствие;
	
	ПравоПросмотраКорзина           = ПравоДоступа("Просмотр", Метаданные.РегистрыСведений.КорзинаПокупателя);
	ПравоПросмотраЗаказКлиента      = ПравоДоступа("Просмотр", Метаданные.Документы.ЗаказКлиента);
	ПравоПросмотраРасчетыСКлиентами = ПравоДоступа("Просмотр", Метаданные.РегистрыНакопления.РасчетыСКлиентами);
	ПравоПросмотрАнкеты             = ПравоДоступа("Просмотр", Метаданные.Документы.Анкета);
	ПравоИзмененияПартнер           = РольДоступна("СамообслуживаниеВнешнийПользовательИзменениеКонтактнойИнформацииКлиента");
	ПравоИзмененияКонтактныеЛица    = ПравоДоступа("Изменение", Метаданные.Справочники.КонтактныеЛицаПартнеров);
	
	Запрос = Новый Запрос;
	
	Запрос.Текст = "
	|ВЫБРАТЬ РАЗРЕШЕННЫЕ
	|	Партнеры.НаименованиеПолное,
	|	Партнеры.Наименование
	|ИЗ
	|	Справочник.Партнеры КАК Партнеры
	|ГДЕ
	|	Партнеры.Ссылка = &Партнер
	|;
	|	
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ РАЗРЕШЕННЫЕ
	|	ПартнерыКонтактнаяИнформация.Представление,
	|	ПартнерыКонтактнаяИнформация.Тип,
	|	ПартнерыКонтактнаяИнформация.Вид
	|ИЗ
	|	Справочник.Партнеры.КонтактнаяИнформация КАК ПартнерыКонтактнаяИнформация
	|ГДЕ
	|	ПартнерыКонтактнаяИнформация.Ссылка = &Партнер
	|";
	
	СоответствиеИнформацииНомеровЗапроса.Вставить("ДанныеПартнера", ТекущийНомерЗапроса);
	СоответствиеИнформацииНомеровЗапроса.Вставить("ДанныеКонтактнаяИнформацияПартнера", ТекущийНомерЗапроса + 1);
	ТекущийНомерЗапроса = ТекущийНомерЗапроса + 2;
	
	Если ПравоПросмотраКорзина Тогда
		
		Запрос.Текст = Запрос.Текст + "
		|;
		|
		|////////////////////////////////////////////////////////////////////////////////
		|ВЫБРАТЬ РАЗРЕШЕННЫЕ
		|	КОЛИЧЕСТВО(ВложенныйЗапрос.Номенклатура) КАК КоличествоТоваров
		|ИЗ
		|	(ВЫБРАТЬ РАЗЛИЧНЫЕ
		|		КорзинаПокупателя.Номенклатура КАК Номенклатура,
		|		КорзинаПокупателя.Характеристика КАК Характеристика
		|	ИЗ
		|		РегистрСведений.КорзинаПокупателя КАК КорзинаПокупателя
		|	ГДЕ
		|		КорзинаПокупателя.ОбъектАвторизации = &ОбъектАвторизации) КАК ВложенныйЗапрос
		|";
		
		СоответствиеИнформацииНомеровЗапроса.Вставить("ДанныеКорзины", ТекущийНомерЗапроса);
		ТекущийНомерЗапроса = ТекущийНомерЗапроса + 1;
	
	КонецЕсли;
	
	Если ПравоПросмотраЗаказКлиента Тогда
		
		Запрос.Текст = Запрос.Текст + "
		|;
		|
		|////////////////////////////////////////////////////////////////////////////////
		|ВЫБРАТЬ РАЗРЕШЕННЫЕ
		|	КОЛИЧЕСТВО(РАЗЛИЧНЫЕ ЗаказКлиента.Ссылка) КАК Количество
		|ИЗ
		|	Документ.ЗаказКлиента КАК ЗаказКлиента
		|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ Справочник.СоглашенияСКлиентами КАК СоглашенияСКлиентами
		|		ПО ЗаказКлиента.Соглашение = СоглашенияСКлиентами.Ссылка
		|ГДЕ
		|	ЗаказКлиента.Проведен
		|	И НЕ ЗаказКлиента.Статус = ЗНАЧЕНИЕ(Перечисление.СтатусыЗаказовКлиентов.Закрыт)
		|	И ЗаказКлиента.Партнер = &Партнер
		|	И СоглашенияСКлиентами.ДоступноВнешнимПользователям
		|";
		
		СоответствиеИнформацииНомеровЗапроса.Вставить("ДанныеЗаказы", ТекущийНомерЗапроса);
		ТекущийНомерЗапроса = ТекущийНомерЗапроса + 1;
		
	КонецЕсли;
	
	Если ПравоПросмотраРасчетыСКлиентами Тогда
		
		Запрос.Текст = Запрос.Текст + "
		|;
		|
		|////////////////////////////////////////////////////////////////////////////////
		|ВЫБРАТЬ РАЗРЕШЕННЫЕ
		|	ВЫБОР
		|		КОГДА РасчетыСКлиентамиОстатки.СуммаОстаток > 0
		|			ТОГДА РасчетыСКлиентамиОстатки.СуммаОстаток
		|		ИНАЧЕ 0
		|	КОНЕЦ КАК СуммаОстаток,
		|	ВЫБОР
		|		КОГДА РасчетыСКлиентамиОстатки.КОплатеОстаток > 0
		|			ТОГДА РасчетыСКлиентамиОстатки.КОплатеОстаток
		|		ИНАЧЕ 0
		|	КОНЕЦ КАК КОплатеОстаток,
		|	РасчетыСКлиентамиОстатки.Валюта
		|ИЗ
		|	РегистрНакопления.РасчетыСКлиентами.Остатки(, ОбъектРасчетов.Партнер = &Партнер) КАК РасчетыСКлиентамиОстатки
		|";
		
		СоответствиеИнформацииНомеровЗапроса.Вставить("ДанныеРасчетыСКлиентами", ТекущийНомерЗапроса);
		ТекущийНомерЗапроса = ТекущийНомерЗапроса + 1;
		
	КонецЕсли;
	
	Если Не АвторизованПартнер Тогда
		
		Запрос.Текст = Запрос.Текст + "
		|;
		|
		|////////////////////////////////////////////////////////////////////////////////
		|ВЫБРАТЬ РАЗРЕШЕННЫЕ
		|	КонтактныеЛицаПартнеров.Наименование,
		|	КонтактныеЛицаПартнеров.ДолжностьПоВизитке
		|ИЗ
		|	Справочник.КонтактныеЛицаПартнеров КАК КонтактныеЛицаПартнеров
		|ГДЕ
		|	КонтактныеЛицаПартнеров.Ссылка = &КонтактноеЛицо
		|;
		|
		|////////////////////////////////////////////////////////////////////////////////
		|ВЫБРАТЬ РАЗРЕШЕННЫЕ
		|	КонтактныеЛицаПартнеровКонтактнаяИнформация.Тип,
		|	КонтактныеЛицаПартнеровКонтактнаяИнформация.Вид,
		|	КонтактныеЛицаПартнеровКонтактнаяИнформация.Представление
		|ИЗ
		|	Справочник.КонтактныеЛицаПартнеров.КонтактнаяИнформация КАК КонтактныеЛицаПартнеровКонтактнаяИнформация
		|ГДЕ
		|	КонтактныеЛицаПартнеровКонтактнаяИнформация.Ссылка = &КонтактноеЛицо
		|";
		
		Запрос.УстановитьПараметр("КонтактноеЛицо", КонтактноеЛицо);
		СоответствиеИнформацииНомеровЗапроса.Вставить("ДанныеКонтактноеЛицо", ТекущийНомерЗапроса);
		СоответствиеИнформацииНомеровЗапроса.Вставить("ДанныеКонтактнаяИнформацияКонтактногоЛица", ТекущийНомерЗапроса + 1);
		ТекущийНомерЗапроса = ТекущийНомерЗапроса + 2;
		
	КонецЕсли;
	
	Запрос.УстановитьПараметр("ОбъектАвторизации", ?(АвторизованПартнер, Партнер, КонтактноеЛицо));
	Запрос.УстановитьПараметр("Партнер",Партнер);
	Запрос.УстановитьПараметр("ТекущаяДата",ТекущаяДатаСеанса());
	
	Результат = Запрос.ВыполнитьПакет();
	
	НаименованиеПартнера = "";
	ВыборкаНаименованиеПартнера = Результат[СоответствиеИнформацииНомеровЗапроса.Получить("ДанныеПартнера")].Выбрать();
	Если ВыборкаНаименованиеПартнера.Следующий() Тогда
		НаименованиеПартнера = ?(ПустаяСтрока(ВыборкаНаименованиеПартнера.НаименованиеПолное),ВыборкаНаименованиеПартнера.Наименование,ВыборкаНаименованиеПартнера.НаименованиеПолное);
	КонецЕсли;
	ПриветственнаяИнформация = СтрЗаменить(ПриветственнаяИнформация,"#PartnerFullName#",НаименованиеПартнера);
	
	Если ПравоПросмотрАнкеты Тогда
		КоличествоАнкет = 0;
		ТаблицаАнкет = Анкетирование.ТаблицаДоступныхРеспондентуАнкет(?(АвторизованПартнер, Партнер, КонтактноеЛицо));
		Если ТаблицаАнкет <> Неопределено Тогда
			КоличествоАнкет = ТаблицаАнкет.Количество();
		КонецЕсли;
		ПриветственнаяИнформация = СтрЗаменить(ПриветственнаяИнформация,"#NumberOfAvaibleQuestionnary#",КоличествоАнкет);
		ПриветственнаяИнформация = СтрЗаменить(ПриветственнаяИнформация,"#QN#","");
	Иначе
		ОбщегоНазначенияУТКлиентСервер.УдалитьИзСтрокиПодстроку(ПриветственнаяИнформация, "#QN#");
	КонецЕсли;
	
	Если Не АвторизованПартнер Тогда
		НаименованиеКонтактногоЛица = "";
		ВыборкаИнформацияКонтактногоЛица = Результат[СоответствиеИнформацииНомеровЗапроса.Получить("ДанныеКонтактноеЛицо")].Выбрать();
		Если ВыборкаИнформацияКонтактногоЛица.Следующий() Тогда
			НаименованиеКонтактногоЛица = ВыборкаИнформацияКонтактногоЛица.Наименование 
			                              + ?(ПустаяСтрока(ВыборкаИнформацияКонтактногоЛица.ДолжностьПоВизитке),
			                                  "",
			                                  ", " + ВыборкаИнформацияКонтактногоЛица.ДолжностьПоВизитке);
		КонецЕсли;
		ПриветственнаяИнформация = СтрЗаменить(ПриветственнаяИнформация,"#ContactPersonName#",НаименованиеКонтактногоЛица);
	КонецЕсли;
	
	НомерЗапроса = СоответствиеИнформацииНомеровЗапроса.Получить("ДанныеКорзины");
	Если НомерЗапроса = Неопределено Тогда
		ОбщегоНазначенияУТКлиентСервер.УдалитьИзСтрокиПодстроку(ПриветственнаяИнформация, "#CD#");
	Иначе
		ВыборкаТоварыКорзины = Результат[НомерЗапроса].Выбрать();
		Если ВыборкаТоварыКорзины.Следующий() Тогда
			ПриветственнаяИнформация = СтрЗаменить(ПриветственнаяИнформация,"#ItemsInTheCart#",ВыборкаТоварыКорзины.КоличествоТоваров);
		Иначе
			ПриветственнаяИнформация = СтрЗаменить(ПриветственнаяИнформация,"#ItemsInTheCart#",0);
		КонецЕсли;
		ПриветственнаяИнформация = СтрЗаменить(ПриветственнаяИнформация,"#CD#","");
	КонецЕсли;
	
	НомерЗапроса = СоответствиеИнформацииНомеровЗапроса.Получить("ДанныеЗаказы");
	Если НомерЗапроса = Неопределено Тогда
		ОбщегоНазначенияУТКлиентСервер.УдалитьИзСтрокиПодстроку(ПриветственнаяИнформация, "#OD#");
	Иначе
		Если ПолучитьФункциональнуюОпцию("ИспользоватьРасширенныеВозможностиЗаказаКлиента") Тогда
			ПриветственнаяИнформация = СтрЗаменить(ПриветственнаяИнформация, 
			"#OrdersProcessed#", 
			НСтр("ru = 'Обрабатывается заказов в данный момент - %КоличествоОбрабатываемыхЗаказов%.'"));
		Иначе
			ПриветственнаяИнформация = СтрЗаменить(ПриветственнаяИнформация, 
			"#OrdersProcessed#", 
			НСтр("ru = 'Всего %КоличествоОбрабатываемыхЗаказов% ваших заказов.'"));
		КонецЕсли; 
		
		ВыборкаЗаказыВОбработке = Результат[НомерЗапроса].Выбрать();
		Если ВыборкаЗаказыВОбработке.Следующий() Тогда
			ПриветственнаяИнформация = СтрЗаменить(ПриветственнаяИнформация,"%КоличествоОбрабатываемыхЗаказов%",ВыборкаЗаказыВОбработке.Количество);
		Иначе
			ПриветственнаяИнформация = СтрЗаменить(ПриветственнаяИнформация,"%КоличествоОбрабатываемыхЗаказов%",0);
		КонецЕсли;
		ПриветственнаяИнформация = СтрЗаменить(ПриветственнаяИнформация,"#OD#","");
	КонецЕсли;
	
	НомерЗапроса = СоответствиеИнформацииНомеровЗапроса.Получить("ДанныеРасчетыСКлиентами");
	Если НомерЗапроса = Неопределено Тогда
		ОбщегоНазначенияУТКлиентСервер.УдалитьИзСтрокиПодстроку(ПриветственнаяИнформация, "#CS#");
	Иначе
		Если НЕ Результат[НомерЗапроса].Пустой() Тогда
			СтрокаСуммаОстаток = "";
			СтрокаКОплатеОстаток = "";
			ВыборкаВзаиморасчеты = Результат[НомерЗапроса].Выбрать();
			Пока ВыборкаВзаиморасчеты.Следующий() Цикл
				СтрокаСуммаОстаток   = СтрокаСуммаОстаток + ?(ВыборкаВзаиморасчеты.СуммаОстаток > 0,
				                                              Строка(ВыборкаВзаиморасчеты.СуммаОстаток) + " " + Строка(ВыборкаВзаиморасчеты.Валюта)+ " ",
				                                              "");
				СтрокаКОплатеОстаток = СтрокаКОплатеОстаток + ?(ВыборкаВзаиморасчеты.КОплатеОстаток > 0,
				                                                Строка(ВыборкаВзаиморасчеты.КОплатеОстаток) + " " + Строка(ВыборкаВзаиморасчеты.Валюта)+ " ",
				                                                "");
			КонецЦикла; 
			ПриветственнаяИнформация = СтрЗаменить(ПриветственнаяИнформация,"#CurrentDebt#",
			                                       ?(ПустаяСтрока(СтрокаСуммаОстаток),НСтр("ru = 'нет'") + " ",СтрокаСуммаОстаток));
			ПриветственнаяИнформация = СтрЗаменить(ПриветственнаяИнформация,"#CurrentDebtOnOrders#",
			                                       ?(ПустаяСтрока(СтрокаКОплатеОстаток),НСтр("ru = 'нет'") + " ",СтрокаКОплатеОстаток ));
		Иначе
			ПриветственнаяИнформация = СтрЗаменить(ПриветственнаяИнформация,"#CurrentDebt#",НСтр("ru = 'нет'"));
			ПриветственнаяИнформация = СтрЗаменить(ПриветственнаяИнформация,"#CurrentDebtOnOrders#",НСтр("ru = 'нет'"));
		КонецЕсли;
		ПриветственнаяИнформация = СтрЗаменить(ПриветственнаяИнформация,"#CS#","");
	КонецЕсли;
	
	Если Результат[СоответствиеИнформацииНомеровЗапроса.Получить("ДанныеКонтактнаяИнформацияПартнера")].Пустой() Тогда
		ПриветственнаяИнформация = СтрЗаменить(ПриветственнаяИнформация,"#ContactInformation#",НСтр("ru = 'не указана.'"));
	Иначе
		СтрокаКИ = "";
		ВыборкаКИ = Результат[СоответствиеИнформацииНомеровЗапроса.Получить("ДанныеКонтактнаяИнформацияПартнера")].Выбрать();
		Пока ВыборкаКИ.Следующий() Цикл
			Если Не ЗначениеЗаполнено(ВыборкаКИ.Вид) Тогда
				Продолжить;
			КонецЕсли;
			СтрокаКИ = СтрокаКИ + Строка(ВыборкаКИ.Вид) + ": " + Строка(ВыборкаКИ.Представление) + "<br>"
		КонецЦикла;
		ПриветственнаяИнформация = СтрЗаменить(ПриветственнаяИнформация,"#ContactInformation#",
		                                       ?(ПустаяСтрока(СтрокаКИ),НСтр("ru = 'не указана.'"),СтрокаКИ));
	КонецЕсли;
	
	Если Не АвторизованПартнер Тогда
		Если Результат[СоответствиеИнформацииНомеровЗапроса.Получить("ДанныеКонтактнаяИнформацияКонтактногоЛица")].Пустой() Тогда
			ПриветственнаяИнформация = СтрЗаменить(ПриветственнаяИнформация,"#ContactInformationContactPerson#",НСтр("ru = 'не указана.'"));
		Иначе
			СтрокаКИ = "";
			ВыборкаКИКЛ = Результат[СоответствиеИнформацииНомеровЗапроса.Получить("ДанныеКонтактнаяИнформацияКонтактногоЛица")].Выбрать();
			Пока ВыборкаКИКЛ.Следующий() Цикл
				СтрокаКИ = СтрокаКИ + Строка(ВыборкаКИКЛ.Вид) + ": " + Строка(ВыборкаКИКЛ.Представление) + "<br>"
			КонецЦикла;
			ПриветственнаяИнформация = СтрЗаменить(ПриветственнаяИнформация,"#ContactInformationContactPerson#",
			                                       ?(ПустаяСтрока(СтрокаКИ),НСтр("ru = 'не указана.'"),СтрокаКИ));
		КонецЕсли;
		
		Если ПравоИзмененияКонтактныеЛица Тогда
			ПриветственнаяИнформация = СтрЗаменить(ПриветственнаяИнформация,"#CC#","");
		Иначе
			ОбщегоНазначенияУТКлиентСервер.УдалитьИзСтрокиПодстроку(ПриветственнаяИнформация, "#CC#");
		КонецЕсли;
		
	КонецЕсли;
	
	Если ПравоИзмененияПартнер Тогда
		ПриветственнаяИнформация = СтрЗаменить(ПриветственнаяИнформация,"#CP#","");
	Иначе
		ОбщегоНазначенияУТКлиентСервер.УдалитьИзСтрокиПодстроку(ПриветственнаяИнформация, "#CP#");
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти
