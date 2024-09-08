﻿
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	Если Параметры.Свойство("АвтоТест") Тогда // Возврат при получении формы для анализа.
		Возврат;
	КонецЕсли;

	ОбновлениеИнформационнойБазы.ПроверитьОбъектОбработан(Запись, ЭтотОбъект);

	Если Параметры.Ключ.Пустой() Тогда
		ИспользованиеСерий = НоменклатураСервер.СерияУказанаКорректно(
								Запись.Склад,
								Запись.Номенклатура,
								Запись.Серия,
								"УказыватьПриПланированииОтгрузки");
								
		ЗаполнитьЗначенияСвойств(Запись, ИспользованиеСерий);
		
		ПриЧтенииСозданииНаСервере();
	КонецЕсли;
КонецПроцедуры

&НаСервере
Процедура ПриЧтенииНаСервере(ТекущийОбъект)

	// СтандартныеПодсистемы.УправлениеДоступом
	УправлениеДоступом.ПриЧтенииНаСервере(ЭтотОбъект, ТекущийОбъект);
	// Конец СтандартныеПодсистемы.УправлениеДоступом

	ПриЧтенииСозданииНаСервере();
КонецПроцедуры

&НаКлиенте
Процедура НоменклатураПриИзменении(Элемент)
	НоменклатураПриИзмененииСервер();
КонецПроцедуры

&НаКлиенте
Процедура ХарактеристикаПриИзменении(Элемент)
	ПриИзмененииИзмерения();
КонецПроцедуры

&НаКлиенте
Процедура СерияПриИзменении(Элемент)
	ПриИзмененииИзмерения();
КонецПроцедуры

&НаКлиенте
Процедура УпаковкаПриИзменении(Элемент)
	ПриИзмененииИзмерения();
КонецПроцедуры

&НаКлиенте
Процедура НазначеноПользователемПриИзменении(Элемент)
	НазначеноПользователемПриИзмененииСервер();
КонецПроцедуры

&НаКлиенте
Процедура НормативноеКоличествоЗапасаПриИзменении(Элемент)
	ОбновитьНадписьПояснение();
КонецПроцедуры

&НаСервере
Процедура ПослеЗаписиНаСервере(ТекущийОбъект, ПараметрыЗаписи)

	// СтандартныеПодсистемы.УправлениеДоступом
	УправлениеДоступом.ПослеЗаписиНаСервере(ЭтотОбъект, ТекущийОбъект, ПараметрыЗаписи);
	// Конец СтандартныеПодсистемы.УправлениеДоступом

КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

#Область ПриИзмененииРеквизитов

&НаСервере
Процедура НоменклатураПриИзмененииСервер();
	СтруктураДействий = Новый Структура;
	СтруктураДействий.Вставить("ПроверитьХарактеристикуПоВладельцу",     Запись.Характеристика);
	СтруктураДействий.Вставить("ПроверитьЗаполнитьУпаковкуПоВладельцу" , Запись.Упаковка);

	СтруктураСтроки = Новый Структура;
	СтруктураСтроки.Вставить("Номенклатура", Запись.Номенклатура);
	СтруктураСтроки.Вставить("Характеристика", Запись.Характеристика);
	СтруктураСтроки.Вставить("Упаковка", Запись.Упаковка);
	СтруктураСтроки.Вставить("ХарактеристикиИспользуются", ХарактеристикиИспользуются);
	
	ОбработкаТабличнойЧастиСервер.ОбработатьСтрокуТЧ(СтруктураСтроки, СтруктураДействий, Неопределено);

	ЗаполнитьЗначенияСвойств(Запись, СтруктураСтроки);
	
	ХарактеристикиИспользуются = СтруктураСтроки.ХарактеристикиИспользуются;
	Элементы.Характеристика.Доступность = ХарактеристикиИспользуются;
	
	ИспользованиеСерий = НоменклатураСервер.СерияУказанаКорректно(
													Запись.Склад,
													Запись.Номенклатура,
													Запись.Серия,
													"УказыватьПриПланированииОтгрузки");
	
	ЗаполнитьЗначенияСвойств(Запись, ИспользованиеСерий);
	
	Элементы.Серия.Доступность = (Запись.СтатусУказанияСерий <> 0);
	
	ПриИзмененииИзмерения();
КонецПроцедуры

&НаСервере
Процедура НазначеноПользователемПриИзмененииСервер()
	Если НазначеноПользователем = 1 Тогда
		Запись.НазначеноПользователем = Истина;
	Иначе
		Запись.НазначеноПользователем = Ложь;
	КонецЕсли;
	
	Элементы.НормативноеКоличествоЗапаса.Доступность = Запись.НазначеноПользователем;
	
	ОбновитьНадписьПояснение();
КонецПроцедуры

&НаСервере
Процедура ПриИзмененииИзмерения()
	Запись.СреднедневноеПотребление          = 0;		
	Запись.СреднеквадратическоеОтклонение    = 0;			
	Запись.ВероятностьОтгрузкиВТечениеДня    = 0;			
	Запись.Класс			                 = Перечисления.XYZКлассификация.ПустаяСсылка();
	НормативноеКоличествоЗапасаРекомендуемое = 0;
	
	ОбновитьНадписьПояснение();
КонецПроцедуры

#КонецОбласти

#Область Прочее

&НаСервере
Процедура ОбновитьНадписьПояснение()
	
	Если Запись.НазначеноПользователем Тогда
		Если Запись.НормативноеКоличествоЗапаса = 0 Тогда
			ТекстНадписи = НСтр("ru = 'Упаковка не участвует в подпитке, т.к. указано нулевое нормативное значение.'");
		Иначе
			ТекстНадписи = НСтр("ru = 'Упаковка участвует в подпитке, т.к. нормативное значение указано вручную.'");
		КонецЕсли;
	ИначеЕсли Не ЗначениеЗаполнено(Запись.Класс) Тогда
		ТекстНадписи = НСтр("ru = 'Упаковка не участвует в подпитке, т.к. не рассчитаны параметры прогноза.'");
	ИначеЕсли Запись.ВероятностьОтгрузкиВТечениеДня < МинимальнаяВероятностьОтгрузки Тогда
		ТекстНадписи = НСтр("ru = 'Упаковка не участвует в подпитке, т.к. вероятность отгрузки в течение дня меньше минимальной (%МинимальнаяВероятность%%), заданной в настройках подпитки.'");
		ТекстНадписи = СтрЗаменить(ТекстНадписи,"%МинимальнаяВероятность%", Строка(МинимальнаяВероятностьОтгрузки));
	Иначе
		ТекстНадписи = НСтр("ru = 'Упаковка участвует в подпитке, т.к. вероятность отгрузки в течение дня больше минимальной (%МинимальнаяВероятность%%), заданной в настройках подпитки.'");
		ТекстНадписи = СтрЗаменить(ТекстНадписи,"%МинимальнаяВероятность%", Строка(МинимальнаяВероятностьОтгрузки));
	КонецЕсли;		
	
	Элементы.ДекорацияПояснение.Заголовок = ТекстНадписи;
	
КонецПроцедуры

&НаСервере
Процедура ПриЧтенииСозданииНаСервере()
	УстановитьПараметрыФункциональныхОпцийФормы(Новый Структура("Склад", Запись.Склад));
	ХарактеристикиИспользуются = Справочники.Номенклатура.ХарактеристикиИспользуются(Запись.Номенклатура);
	Элементы.Характеристика.Доступность = ХарактеристикиИспользуются;
	Элементы.НормативноеКоличествоЗапаса.Доступность = Запись.НазначеноПользователем;
	Элементы.Серия.Доступность = (Запись.СтатусУказанияСерий <> 0);
	
	Если Запись.НазначеноПользователем Тогда
		НазначеноПользователем = 1;
	Иначе
		НазначеноПользователем = 0;
	КонецЕсли;
	Если Запись.НазначеноПользователем Тогда
		НазначеноПользователем = 1;
	Иначе
		НазначеноПользователем = 0;
	КонецЕсли;
	
	Запрос = Новый Запрос;
	Запрос.Текст =
	"ВЫБРАТЬ
	|	НастройкиАдресныхСкладов.МинимальнаяВероятностьОтгрузки КАК МинимальнаяВероятностьОтгрузки,
	|	НастройкиАдресныхСкладов.УровеньОбслуживанияУпаковокКлассаX КАК УровеньОбслуживанияX,
	|	НастройкиАдресныхСкладов.УровеньОбслуживанияУпаковокКлассаZ КАК УровеньОбслуживанияZ,
	|	НастройкиАдресныхСкладов.УровеньОбслуживанияУпаковокКлассаY КАК УровеньОбслуживанияY
	|ИЗ
	|	РегистрСведений.НастройкиАдресныхСкладов КАК НастройкиАдресныхСкладов
	|ГДЕ
	|	НастройкиАдресныхСкладов.Склад = &Склад
	|	И НастройкиАдресныхСкладов.Помещение = &Помещение";
	Запрос.УстановитьПараметр("Склад", Запись.Склад);
	Запрос.УстановитьПараметр("Помещение", Запись.Помещение);
	
	Выборка = Запрос.Выполнить().Выбрать();
	
	Выборка.Следующий();
	
	МинимальнаяВероятностьОтгрузки = Выборка.МинимальнаяВероятностьОтгрузки;
	
	Если Запись.Класс = Перечисления.XYZКлассификация.XКласс Тогда
		НормативноеКоличествоЗапасаРекомендуемое = Запись.СреднедневноеПотребление 
												 + Запись.СреднеквадратическоеОтклонение
												 * Классификация.ПолучитьКоэффициентУровняОбслуживания(Выборка.УровеньОбслуживанияX);
	ИначеЕсли Запись.Класс = Перечисления.XYZКлассификация.YКласс Тогда
		НормативноеКоличествоЗапасаРекомендуемое = Запись.СреднедневноеПотребление 
												 + Запись.СреднеквадратическоеОтклонение
												 * Классификация.ПолучитьКоэффициентУровняОбслуживания(Выборка.УровеньОбслуживанияY);
	ИначеЕсли Запись.Класс = Перечисления.XYZКлассификация.ZКласс Тогда
		НормативноеКоличествоЗапасаРекомендуемое = Запись.СреднедневноеПотребление 
												 + Запись.СреднеквадратическоеОтклонение
												 * Классификация.ПолучитьКоэффициентУровняОбслуживания(Выборка.УровеньОбслуживанияZ);
	Иначе
		НормативноеКоличествоЗапасаРекомендуемое = 0;
	КонецЕсли;
	
	ОбновитьНадписьПояснение();
КонецПроцедуры

#КонецОбласти

#КонецОбласти
