﻿&НаКлиенте
Перем ПараметрыОбработчикаОжидания;

#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если Параметры.Свойство("АвтоТест") Тогда
		Возврат;
	КонецЕсли;
	
	Отчет.Организация = БухгалтерскийУчетПереопределяемый.ПолучитьЗначениеПоУмолчанию("ОсновнаяОрганизация");
	Отчет.ПериодРегистрации = НачалоКвартала(НачалоДня(ТекущаяДатаСеанса()) - 25 * 24 * 60 * 60);
	ЗаполнитьЗначенияСвойств(Отчет, Параметры);
	ЭтоРеестрПолученныхСчетовФактур = Параметры.КлючВарианта = "ПолученныеСчетаФактуры";
	Отчет.ЧастьЖурнала = ?(ЭтоРеестрПолученныхСчетовФактур, 
		Перечисления.ЧастиЖурналаУчетаСчетовФактур.ПолученныеСчетаФактуры,
		Перечисления.ЧастиЖурналаУчетаСчетовФактур.ВыставленныеСчетаФактуры);
		
	ПредставлениеПериодаРегистрации = ВыборПериодаКлиентСервер.ПолучитьПредставлениеПериодаОтчета(
		Перечисления.ДоступныеПериодыОтчета.Квартал, 
		НачалоКвартала(Отчет.ПериодРегистрации), 
		КонецКвартала(Отчет.ПериодРегистрации));
		
	Элементы.Контрагент.ПодсказкаВвода = ?(ЭтоРеестрПолученныхСчетовФактур, 
		НСтр("ru='Поставщик'"), 
		НСтр("ru='Покупатель'"));
		
	ЕстьПравоВывод = ПравоДоступа("Вывод", Метаданные);
	Элементы.ПечатьСразу.Видимость               = ЕстьПравоВывод;
	Элементы.ПечатьСразуВсеДействия.Видимость    = ЕстьПравоВывод;
	Элементы.ПредварительныйПросмотр.Видимость   = ЕстьПравоВывод И Не ОбщегоНазначения.ЭтоВебКлиент();
	Элементы.ПредварительныйПросмотрВсеДействия.Видимость = Элементы.ПредварительныйПросмотр.Видимость;
	Элементы.ВыгрузитьОтчет.Видимость            = ЕстьПравоВывод И НЕ ЭтоРеестрПолученныхСчетовФактур;
	Элементы.ВыгрузитьОтчетВсеДействия.Видимость = ЕстьПравоВывод И НЕ ЭтоРеестрПолученныхСчетовФактур;
	Элементы.СохранитьКакВсеДействия.Видимость   = ЕстьПравоВывод;

	ОбновитьТекстЗаголовка(ЭтотОбъект);
	
КонецПроцедуры

&НаКлиенте
Процедура ПриЗакрытии(ЗавершениеРаботы)
	
	БухгалтерскиеОтчетыКлиент.ПриЗакрытии(ЭтаФорма, ЗавершениеРаботы);
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура ПредставлениеПериодаРегистрацииНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	ПараметрыВыбора = Новый Структура("НачалоПериода,КонецПериода", 
		НачалоКвартала(Отчет.ПериодРегистрации), КонецКвартала(Отчет.ПериодРегистрации));
	ОткрытьФорму("ОбщаяФорма.ВыборСтандартногоПериодаКвартал", ПараметрыВыбора, Элементы.ПредставлениеПериодаРегистрации);
	
КонецПроцедуры

&НаКлиенте
Процедура ПредставлениеПериодаРегистрацииОбработкаВыбора(Элемент, ВыбранноеЗначение, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	Если ВыбранноеЗначение = Неопределено Тогда
		Возврат;
	КонецЕсли;
	ИзменитьПериод(ВыбранноеЗначение.НачалоПериода);
	
КонецПроцедуры

&НаКлиенте
Процедура ПредставлениеПериодаРегистрацииОчистка(Элемент, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	
КонецПроцедуры

&НаКлиенте
Процедура ПолеОрганизацияПриИзменении(Элемент)
	
	ОбновитьТекстЗаголовка(ЭтотОбъект);
	
	Если НЕ ЗначениеЗаполнено(ИдентификаторЗадания) Тогда
		ОбщегоНазначенияКлиентСервер.УстановитьСостояниеПоляТабличногоДокумента(Элементы.Результат, "НеАктуальность");
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура КонтрагентПриИзменении(Элемент)
	
	Если НЕ ЗначениеЗаполнено(ИдентификаторЗадания) Тогда
		ОбщегоНазначенияКлиентСервер.УстановитьСостояниеПоляТабличногоДокумента(Элементы.Результат, "НеАктуальность");
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура РезультатПриАктивизации(Элемент)
	
	БухгалтерскиеОтчетыКлиент.НачатьРасчетСуммыВыделенныхЯчеек(
		Элементы.Результат,
		ЭтотОбъект,
		"Подключаемый_РезультатПриАктивизацииПодключаемый");
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура УменьшитьПериод(Команда)
	
	ИзменитьПериод(НачалоКвартала(Отчет.ПериодРегистрации - 1));
	
КонецПроцедуры

&НаКлиенте
Процедура УвеличитьПериод(Команда)
	
	ИзменитьПериод(КонецКвартала(Отчет.ПериодРегистрации) + 1);
	
КонецПроцедуры

&НаКлиенте
Процедура СформироватьОтчет(Команда)
	
	НачатьФормированиеОтчета();
	
КонецПроцедуры

&НаКлиенте
Процедура ВыгрузитьОтчет(Команда)
	
	Если НЕ ЗначениеЗаполнено(АдресХранилищаФайлаВыгрузки) ИЛИ НЕ ОтчетСформирован() Тогда
		ТекстСообщения = НСтр("ru='Перед выгрузкой необходимо сформировать отчет.'");
		ПоказатьПредупреждение(, ТекстСообщения);
		Возврат;
	ИначеЕсли НЕ ЗначениеЗаполнено(ИННПокупателя) Тогда
		ТекстСообщения = НСтр("ru='Не заполнено поле ""ИНН"" покупателя, выгрузка невозможна.'");
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(ТекстСообщения, , "Контрагент", "Отчет");
		Возврат;
	ИначеЕсли НЕ ЗначениеЗаполнено(ИННПоставщика) Тогда
		ТекстСообщения = НСтр("ru='Не заполнено поле ""ИНН"" организации, выгрузка невозможна.'");
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(ТекстСообщения, , "Организация", "Отчет");
		Возврат;
	КонецЕсли;
	
	ОписаниеОповещения = Новый ОписаниеОповещения("ПодключитьРасширениеРаботыСФайламиЗавершение", ЭтотОбъект);
	ОбщегоНазначенияКлиент.ПоказатьВопросОбУстановкеРасширенияРаботыСФайлами(ОписаниеОповещения);

КонецПроцедуры

&НаКлиенте
Процедура ПодключитьРасширениеРаботыСФайламиЗавершение(РасширениеПодключено, ДопПараметры) Экспорт
	
	Если РасширениеПодключено Тогда
	
		ДиалогВыбораФайла = Новый ДиалогВыбораФайла(РежимДиалогаВыбораФайла.Сохранение);
		ДиалогВыбораФайла.ПолноеИмяФайла = Элементы.Результат.ИспользуемоеИмяФайла;
		ДиалогВыбораФайла.Фильтр = НСтр("ru='Документ XML (*.xml)|*.xml'");
		ОписаниеОповещения = Новый ОписаниеОповещения("ВыгрузитьОтчетПродолжение", ЭтотОбъект);
		ДиалогВыбораФайла.Показать(ОписаниеОповещения);
		
	Иначе
		
		ПолучитьФайл(АдресХранилищаФайлаВыгрузки, Элементы.Результат.ИспользуемоеИмяФайла + ".xml", Истина);
		
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ВыгрузитьОтчетПродолжение(ВыбранныеФайлы, ДопПараметры) Экспорт
	
	Если ВыбранныеФайлы = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	ИмяСохраняемогоФайла = ВыбранныеФайлы[0];
	
	ОписаниеОповещения = Новый ОписаниеОповещения("ВыгрузитьОтчетЗавершение", ЭтотОбъект);
	ПолучаемыеФайлы    = Новый Массив;
	ОписаниеФайла      = Новый ОписаниеПередаваемогоФайла(ИмяСохраняемогоФайла, АдресХранилищаФайлаВыгрузки);
	ПолучаемыеФайлы.Добавить(ОписаниеФайла);
	НачатьПолучениеФайлов(ОписаниеОповещения, ПолучаемыеФайлы, , Ложь);
	
КонецПроцедуры

&НаКлиенте
Процедура ВыгрузитьОтчетЗавершение(ПолученныеФайлы, ДопПараметры) Экспорт
	
	Если ПолученныеФайлы = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	ИмяСохраненногоФайла = ПолученныеФайлы[0].Имя;
	ТекстСообщения       = НСтр("ru='Файл сохранен:'");
	ПоказатьОповещениеПользователя(ТекстСообщения, , ИмяСохраненногоФайла);
	
КонецПроцедуры

&НаКлиентеНаСервереБезКонтекста
Процедура ОбновитьТекстЗаголовка(Форма)
	
	Отчет = Форма.Отчет;
	
	Форма.Заголовок = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
		?(Отчет.ЧастьЖурнала = ПредопределенноеЗначение(
			"Перечисление.ЧастиЖурналаУчетаСчетовФактур.ВыставленныеСчетаФактуры"),
		НСтр("ru='Реестр счетов-фактур выданных%1'"),
		НСтр("ru='Реестр счетов-фактур полученных%1'")),
		БухгалтерскиеОтчетыКлиентСервер.ПолучитьПредставлениеПериода(
			НачалоКвартала(Отчет.ПериодРегистрации), 
			КонецКвартала(Отчет.ПериодРегистрации)));
	
КонецПроцедуры

&НаСервере
Функция ПодготовитьПараметрыОтчета()
	
	ПараметрыОтчета = Новый Структура;
	ПараметрыОтчета.Вставить("НалоговыйПериод", Отчет.ПериодРегистрации);
	ПараметрыОтчета.Вставить("Организация",     Отчет.Организация);
	ПараметрыОтчета.Вставить("Контрагент",      Отчет.Контрагент);
	ПараметрыОтчета.Вставить("ЧастьЖурнала",    Отчет.ЧастьЖурнала);
	АдресХранилищаФайлаВыгрузки = ПоместитьВоВременноеХранилище(Неопределено, УникальныйИдентификатор);
	ПараметрыОтчета.Вставить("АдресХранилищаФайлаВыгрузки", АдресХранилищаФайлаВыгрузки);
	Возврат ПараметрыОтчета;
	
КонецФункции

&НаСервере
Функция СформироватьОтчетНаСервере()
	
	Если НЕ ПроверитьЗаполнение() Тогда 
		Возврат Новый Структура("ЗаданиеВыполнено", Истина);
	КонецЕсли;
	
	ДлительныеОперации.ОтменитьВыполнениеЗадания(ИдентификаторЗадания);
	
	ИдентификаторЗадания = Неопределено;
	
	ОбщегоНазначенияКлиентСервер.УстановитьСостояниеПоляТабличногоДокумента(Элементы.Результат, "НеИспользовать");
	
	ПараметрыОтчета = ПодготовитьПараметрыОтчета();
	ИННПоставщика = "";
	ИННПокупателя = "";
	
	РезультатВыполнения = ДлительныеОперации.ЗапуститьВыполнениеВФоне(
		УникальныйИдентификатор, 
		"СверкаДанныхУчетаНДС.СформироватьРеестрСчетовФактур", 
		ПараметрыОтчета, 
		БухгалтерскиеОтчетыКлиентСервер.ПолучитьНаименованиеЗаданияВыполненияОтчета(ЭтотОбъект));
	
	ИдентификаторЗадания = РезультатВыполнения.ИдентификаторЗадания;
	АдресХранилища       = РезультатВыполнения.АдресХранилища;
	
	Если РезультатВыполнения.ЗаданиеВыполнено Тогда
		ЗагрузитьПодготовленныеДанные();
	КонецЕсли;
	
	Возврат РезультатВыполнения;
	
КонецФункции

&НаКлиенте
Процедура Подключаемый_ПроверитьВыполнениеЗадания()

	Попытка
		Если ЗаданиеВыполнено(ИдентификаторЗадания) Тогда
			ЗагрузитьПодготовленныеДанные();
			ОбщегоНазначенияКлиентСервер.УстановитьСостояниеПоляТабличногоДокумента(Элементы.Результат, "НеИспользовать");
		Иначе
			ДлительныеОперацииКлиент.ОбновитьПараметрыОбработчикаОжидания(ПараметрыОбработчикаОжидания);
			ПодключитьОбработчикОжидания(
				"Подключаемый_ПроверитьВыполнениеЗадания",
				ПараметрыОбработчикаОжидания.ТекущийИнтервал,
				Истина);
		КонецЕсли;
	Исключение
		ОбщегоНазначенияКлиентСервер.УстановитьСостояниеПоляТабличногоДокумента(Элементы.Результат, "НеИспользовать");
		ВызватьИсключение;
	КонецПопытки;

КонецПроцедуры

&НаСервере
Процедура ЗагрузитьПодготовленныеДанные()

	РезультатВыполнения = ПолучитьИзВременногоХранилища(АдресХранилища);
	
	ИННПоставщика = РезультатВыполнения.ИННПоставщика;
	ИННПокупателя = РезультатВыполнения.ИННПокупателя;
	
	ИдентификаторЗадания = Неопределено;
	
	// Вывод табличного документа
	
	Результат.Очистить();
	Результат.Вывести(РезультатВыполнения.Реестр);
	
	// Задаем имя файла по умолчанию
	ПериодОтчета = БухгалтерскиеОтчетыКлиентСервер.ПолучитьПредставлениеПериода(
		НачалоКвартала(Отчет.ПериодРегистрации), 
		КонецКвартала(Отчет.ПериодРегистрации));
	ИмяФайла = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
		?(Отчет.ЧастьЖурнала = Перечисления.ЧастиЖурналаУчетаСчетовФактур.ВыставленныеСчетаФактуры,
			НСтр("ru='Счета-фактуры%1 для %2 от %3'"),
			НСтр("ru='Счета-фактуры%1 от %2 по %3'")),
		ПериодОтчета,
		Отчет.Контрагент,
		Отчет.Организация);
	Элементы.Результат.ИспользуемоеИмяФайла = ОбщегоНазначенияКлиентСервер.ЗаменитьНедопустимыеСимволыВИмениФайла(
		СтрЗаменить(ИмяФайла, ".", " "));
	
	Результат.АвтоМасштаб          = Истина;
	Результат.ОриентацияСтраницы   = ОриентацияСтраницы.Ландшафт;
	Результат.КлючПараметровПечати = "ПАРАМЕТРЫ_ПЕЧАТИ_РеестрСчетовФактур";

КонецПроцедуры

&НаСервереБезКонтекста
Функция ЗаданиеВыполнено(ИдентификаторЗадания)
	
	Возврат ДлительныеОперации.ЗаданиеВыполнено(ИдентификаторЗадания);
	
КонецФункции

&НаСервере
Процедура ВычислитьСуммуВыделенныхЯчеекТабличногоДокументаВКонтекстеНаСервере()
	
	ПолеСумма = БухгалтерскиеОтчетыВызовСервера.ВычислитьСуммуВыделенныхЯчеекТабличногоДокумента(
		Результат, КэшВыделеннойОбласти);
	
КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_РезультатПриАктивизацииПодключаемый()
	
	НеобходимоВычислятьНаСервере = Ложь;
	БухгалтерскиеОтчетыКлиент.ВычислитьСуммуВыделенныхЯчеекТабличногоДокумента(
		ПолеСумма, Результат, Элементы.Результат, КэшВыделеннойОбласти, НеобходимоВычислятьНаСервере);
	
	Если НеобходимоВычислятьНаСервере Тогда
		ВычислитьСуммуВыделенныхЯчеекТабличногоДокументаВКонтекстеНаСервере();
	КонецЕсли;
	
	ОтключитьОбработчикОжидания("Подключаемый_РезультатПриАктивизацииПодключаемый");
	
КонецПроцедуры

&НаКлиенте
Процедура ИзменитьПериод(НовыйПериод)

	Отчет.ПериодРегистрации = НовыйПериод;
	ПредставлениеПериодаРегистрации = ВыборПериодаКлиентСервер.ПолучитьПредставлениеПериодаОтчета(
		ПредопределенноеЗначение("Перечисление.ДоступныеПериодыОтчета.Квартал"), 
		НачалоКвартала(Отчет.ПериодРегистрации),
		КонецКвартала(Отчет.ПериодРегистрации));
	
	ОбновитьТекстЗаголовка(ЭтотОбъект);
	
	Если Не ЗначениеЗаполнено(ИдентификаторЗадания) Тогда
		ОбщегоНазначенияКлиентСервер.УстановитьСостояниеПоляТабличногоДокумента(Элементы.Результат, "НеАктуальность");
	КонецЕсли;
	
КонецПроцедуры 

&НаКлиенте
Процедура СохранитьКак(Команда)
	
	БухгалтерскиеОтчетыКлиент.ОтчетСохранитьКак(ЭтотОбъект);

КонецПроцедуры

&НаКлиенте
Процедура ОтправитьПоЭлектроннойПочте(Команда)
	
	Если НЕ ПроверитьЗаполнение() Тогда
		Возврат;
	КонецЕсли;
	
	Если НЕ ОтчетСформирован() Тогда
		СформироватьОтчетПередОтправкойПоПочте();
	Иначе
		ОтправитьПоЭлектроннойПочтеСформированныйОтчет();
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаКлиенте
Процедура НачатьФормированиеОтчета()
	
	ОчиститьСообщения();
	
	ОтключитьОбработчикОжидания("Подключаемый_ПроверитьВыполнениеЗадания");
	
	РезультатВыполнения = СформироватьОтчетНаСервере();
	Если НЕ РезультатВыполнения.ЗаданиеВыполнено Тогда
		ДлительныеОперацииКлиент.ИнициализироватьПараметрыОбработчикаОжидания(ПараметрыОбработчикаОжидания);
		ПодключитьОбработчикОжидания("Подключаемый_ПроверитьВыполнениеЗадания", 1, Истина);
		ОбщегоНазначенияКлиентСервер.УстановитьСостояниеПоляТабличногоДокумента(Элементы.Результат, "ФормированиеОтчета");
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Функция ОтчетСформирован()
	
	ОтчетСформирован = Истина;
	
	ОтображениеСостояния = Элементы.Результат.ОтображениеСостояния;
	Если ОтображениеСостояния.ДополнительныйРежимОтображения = ДополнительныйРежимОтображения.Неактуальность Тогда
		ОтчетСформирован = Ложь;
	КонецЕсли;
	
	Возврат ОтчетСформирован;
	
КонецФункции

#Область ЭлектроннаяПочта

&НаКлиенте
Процедура СформироватьОтчетПередОтправкойПоПочте()
	
	ОтключитьОбработчикОжидания("Подключаемый_ПроверитьВыполнениеЗаданияПередОтправкойПоПочте");
	
	НачатьФормированиеОтчета();
	Если НЕ ОтчетСформирован() Тогда
		ПодключитьОбработчикОжидания("Подключаемый_ПроверитьВыполнениеЗаданияПередОтправкойПоПочте", 1, Истина);
	Иначе
		ОтправитьПоЭлектроннойПочтеСформированныйОтчет();
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_ПроверитьВыполнениеЗаданияПередОтправкойПоПочте()
	
	Если ОтчетСформирован() Тогда
		ОтключитьОбработчикОжидания("Подключаемый_ПроверитьВыполнениеЗаданияПередОтправкойПоПочте");
		ОтправитьПоЭлектроннойПочтеСформированныйОтчет();
	Иначе
		ПодключитьОбработчикОжидания(
			"Подключаемый_ПроверитьВыполнениеЗаданияПередОтправкойПоПочте",
			ПараметрыОбработчикаОжидания.ТекущийИнтервал,
			Истина);
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ОтправитьПоЭлектроннойПочтеСформированныйОтчет()
	
	ДопПараметры = Новый Структура;
	
	Если Отчет.ЧастьЖурнала = ПредопределенноеЗначение("Перечисление.ЧастиЖурналаУчетаСчетовФактур.ВыставленныеСчетаФактуры") Тогда
		
		Вложения = Новый Соответствие;
		ИмяФайлаВложения = Элементы.Результат.ИспользуемоеИмяФайла + ".xml";
		Вложения.Вставить(АдресХранилищаФайлаВыгрузки, ИмяФайлаВложения);
		ДопПараметры.Вставить("ДопВложения", Вложения);
		
		ДопПараметры.Вставить("Тема"    , Элементы.Результат.ИспользуемоеИмяФайла);
		ДопПараметры.Вставить("ИмяФайла", Элементы.Результат.ИспользуемоеИмяФайла);
		
	КонецЕсли;
	
	Если ЗначениеЗаполнено(Отчет.Контрагент) Тогда
		ДопПараметры.Вставить("Контрагент", Отчет.Контрагент);
	КонецЕсли;
	
	ОтправкаПочтовыхСообщенийКлиент.ОтправитьОтчет(ЭтотОбъект, ДопПараметры);
	
КонецПроцедуры

#КонецОбласти

#КонецОбласти
