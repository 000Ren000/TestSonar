﻿
#Область ОписаниеПеременных

&НаКлиенте
Перем ОбновитьИнтерфейс;

#КонецОбласти

#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если Параметры.Свойство("АвтоТест") Тогда
		Возврат;
	КонецЕсли;
	
	// Значения реквизитов формы
	СоставНабораКонстантФормы    = ОбщегоНазначенияУТ.ПолучитьСтруктуруНабораКонстант(НаборКонстант);
	ВнешниеРодительскиеКонстанты = НастройкиСистемыПовтИсп.ПолучитьСтруктуруРодительскихКонстант(СоставНабораКонстантФормы);
	РежимРаботы = Новый Структура;
	
	ВнешниеРодительскиеКонстанты.Вставить("ИспользоватьПроизводство");
	ВнешниеРодительскиеКонстанты.Вставить("ИспользоватьТоварныеКатегории");
	ВнешниеРодительскиеКонстанты.Вставить("ИспользоватьСборкуРазборку");
	
	РежимРаботы.Вставить("СоставНабораКонстантФормы",    Новый ФиксированнаяСтруктура(СоставНабораКонстантФормы));
	РежимРаботы.Вставить("ВнешниеРодительскиеКонстанты", Новый ФиксированнаяСтруктура(ВнешниеРодительскиеКонстанты));
	
	РежимРаботы = Новый ФиксированнаяСтруктура(РежимРаботы);
	
	Если ПолучитьФункциональнуюОпцию("УправлениеПредприятием")
		Или ПолучитьФункциональнуюОпцию("КомплекснаяАвтоматизация") Тогда
		Элементы.ОписаниеРаздела.Заголовок = НСтр("ru = 'Настройка параметров бюджетирования и планирования.'");
	Иначе
		Элементы.ОписаниеРаздела.Заголовок = НСтр("ru = 'Настройка параметров планирования.'");
		
		Элементы.ГруппаНастройкиБюджетирования.Видимость = Ложь;
		Элементы.ГруппаИспользоватьПланирование.ОтображатьЗаголовок = Ложь;
	КонецЕсли;
	
	
	
	Если ПолучитьФункциональнуюОпцию("РаботаВМоделиСервиса") Тогда
		Элементы.АдресПубликацииИнформационнойБазыВЛокальнойСети.Видимость = Ложь;
	КонецЕсли;
	
	// Обновление состояния элементов
	УстановитьДоступность();
	
КонецПроцедуры

&НаКлиенте
Процедура ПриЗакрытии(ЗавершениеРаботы)
	Если ЗавершениеРаботы Тогда
		Возврат;
	КонецЕсли;
	ОбновитьИнтерфейсПрограммы();
КонецПроцедуры

&НаКлиенте
// Обработчик оповещения формы.
//
// Параметры:
//	ИмяСобытия - Строка - обрабатывается только событие Запись_НаборКонстант, генерируемое панелями администрирования.
//	Параметр   - Структура - содержит имена констант, подчиненных измененной константе, "вызвавшей" оповещение.
//	Источник   - Строка - имя измененной константы, "вызвавшей" оповещение.
//
Процедура ОбработкаОповещения(ИмяСобытия, Параметр, Источник)
	
	Если ИмяСобытия <> "Запись_НаборКонстант" Тогда
		Возврат; // такие событие не обрабатываются
	КонецЕсли;
	
	// Если это изменена константа, расположенная в другой форме и влияющая на значения констант этой формы,
	// то прочитаем значения констант и обновим элементы этой формы.
	Если РежимРаботы.ВнешниеРодительскиеКонстанты.Свойство(Источник)
	 ИЛИ (ТипЗнч(Параметр) = Тип("Структура")
	 		И ОбщегоНазначенияУТКлиентСервер.ПолучитьОбщиеКлючиСтруктур(
	 			Параметр, РежимРаботы.ВнешниеРодительскиеКонстанты).Количество() > 0) Тогда
		
		ЭтаФорма.Прочитать();
		УстановитьДоступность();
		
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура ИспользоватьБюджетированиеПриИзменении(Элемент)
	Подключаемый_ПриИзмененииРеквизита(Элемент);
КонецПроцедуры

&НаКлиенте
Процедура ИспользоватьБюджетныйПроцессПриИзменении(Элемент)
	Подключаемый_ПриИзмененииРеквизита(Элемент);
КонецПроцедуры

&НаКлиенте
Процедура ИспользоватьОповещенияДляЗадачБюджетированияПриИзменении(Элемент)
	Подключаемый_ПриИзмененииРеквизита(Элемент, Ложь);
КонецПроцедуры

&НаКлиенте
Процедура АдресПубликацииИнформационнойБазыВЛокальнойСетиПриИзменении(Элемент)
	
	Подключаемый_ПриИзмененииРеквизита(Элемент, Ложь);
	
КонецПроцедуры

&НаКлиенте
Процедура АктуализироватьФактБюджетированияПриПроведенииДокументовПриИзменении(Элемент)
	
	Подключаемый_ПриИзмененииРеквизита(Элемент, Ложь);
	
КонецПроцедуры

&НаКлиенте
Процедура АктуализироватьФактБюджетированияПриФормированииОтчетовПриИзменении(Элемент)
	
	Подключаемый_ПриИзмененииРеквизита(Элемент, Ложь);
	
КонецПроцедуры

&НаКлиенте
Процедура ВариантНастройкиПравилПоРегистрамОстатковПриИзменении(Элемент)
	
	Возврат;
	
КонецПроцедуры

&НаКлиенте
Процедура ВариантНастройкиПравилПоРегистрамОборотовПриИзменении(Элемент)
	
	Возврат;
	
КонецПроцедуры

&НаКлиенте
Процедура ИспользоватьПланированиеПродажПриИзменении(Элемент)
	Подключаемый_ПриИзмененииРеквизита(Элемент);
	Если НЕ (НаборКонстант.ИспользоватьПланированиеПродаж
			ИЛИ НаборКонстант.ИспользоватьПланированиеСборкиРазборки
			ИЛИ НаборКонстант.ИспользоватьПланированиеЗакупок
			ИЛИ НаборКонстант.ИспользоватьПланированиеВнутреннихПотреблений) 
			И НаборКонстант.ИспользоватьСезонныеКоэффициенты Тогда
		НаборКонстант.ИспользоватьСезонныеКоэффициенты = Ложь;
		Подключаемый_ПриИзмененииРеквизита(Элементы.ИспользоватьСезонныеКоэффициенты);
	КонецЕсли;
КонецПроцедуры

&НаКлиенте
Процедура ИспользоватьПланированиеПродажПоКатегориямПриИзменении(Элемент)
	
	Подключаемый_ПриИзмененииРеквизита(Элемент);
	
КонецПроцедуры

&НаКлиенте
Процедура ИспользоватьПланированиеВнутреннихПотребленийПриИзменении(Элемент)
	Подключаемый_ПриИзмененииРеквизита(Элемент);
	Если НЕ (НаборКонстант.ИспользоватьПланированиеПродаж
			ИЛИ НаборКонстант.ИспользоватьПланированиеСборкиРазборки
			ИЛИ НаборКонстант.ИспользоватьПланированиеЗакупок
			ИЛИ НаборКонстант.ИспользоватьПланированиеВнутреннихПотреблений) 
			И НаборКонстант.ИспользоватьСезонныеКоэффициенты Тогда
		НаборКонстант.ИспользоватьСезонныеКоэффициенты = Ложь;
		Подключаемый_ПриИзмененииРеквизита(Элементы.ИспользоватьСезонныеКоэффициенты);
	КонецЕсли;
КонецПроцедуры

&НаКлиенте
Процедура ИспользоватьСезонныеКоэффициентыПриИзменении(Элемент)
	
	Подключаемый_ПриИзмененииРеквизита(Элемент);
	Если НЕ ЗначениеЗаполнено(НаборКонстант.ПериодичностьВводаСезонныхКоэффициентов) Тогда
		НаборКонстант.ПериодичностьВводаСезонныхКоэффициентов = ПредопределенноеЗначение("Перечисление.Периодичность.Месяц");
		Подключаемый_ПриИзмененииРеквизита(Элементы.ПериодичностьВводаСезонныхКоэффициентов, Ложь);
	КонецЕсли; 
	
КонецПроцедуры

&НаКлиенте
Процедура ПериодичностьВводаСезонныхКоэффициентовПриИзменении(Элемент)
	
	Подключаемый_ПриИзмененииРеквизита(Элемент, Ложь);
	
КонецПроцедуры

&НаКлиенте
Процедура ИспользоватьПланированиеСборкиРазборкиПриИзменении(Элемент)
	Подключаемый_ПриИзмененииРеквизита(Элемент);
	Если НЕ (НаборКонстант.ИспользоватьПланированиеПродаж
			ИЛИ НаборКонстант.ИспользоватьПланированиеСборкиРазборки
			ИЛИ НаборКонстант.ИспользоватьПланированиеЗакупок
			ИЛИ НаборКонстант.ИспользоватьПланированиеВнутреннихПотреблений) 
			И НаборКонстант.ИспользоватьСезонныеКоэффициенты Тогда
		НаборКонстант.ИспользоватьСезонныеКоэффициенты = Ложь;
		Подключаемый_ПриИзмененииРеквизита(Элементы.ИспользоватьСезонныеКоэффициенты);
	КонецЕсли;
КонецПроцедуры

&НаКлиенте
Процедура ИспользоватьПланированиеПроизводстваПриИзменении(Элемент)
	Подключаемый_ПриИзмененииРеквизита(Элемент);
	Если НЕ (НаборКонстант.ИспользоватьПланированиеПродаж
			ИЛИ НаборКонстант.ИспользоватьПланированиеСборкиРазборки
			ИЛИ НаборКонстант.ИспользоватьПланированиеЗакупок
			ИЛИ НаборКонстант.ИспользоватьПланированиеВнутреннихПотреблений) 
			И НаборКонстант.ИспользоватьСезонныеКоэффициенты Тогда
		НаборКонстант.ИспользоватьСезонныеКоэффициенты = Ложь;
		Подключаемый_ПриИзмененииРеквизита(Элементы.ИспользоватьСезонныеКоэффициенты);
	КонецЕсли;
КонецПроцедуры

&НаКлиенте
Процедура ИспользоватьПланированиеЗакупокПриИзменении(Элемент)
	Подключаемый_ПриИзмененииРеквизита(Элемент);
	Если НЕ (НаборКонстант.ИспользоватьПланированиеПродаж
			ИЛИ НаборКонстант.ИспользоватьПланированиеСборкиРазборки
			ИЛИ НаборКонстант.ИспользоватьПланированиеЗакупок
			ИЛИ НаборКонстант.ИспользоватьПланированиеВнутреннихПотреблений) 
			И НаборКонстант.ИспользоватьСезонныеКоэффициенты Тогда
		НаборКонстант.ИспользоватьСезонныеКоэффициенты = Ложь;
		Подключаемый_ПриИзмененииРеквизита(Элементы.ИспользоватьСезонныеКоэффициенты);
	КонецЕсли;
КонецПроцедуры

&НаКлиенте
Процедура РаспараллеливатьРасчетПлановПроизводстваПриИзменении(Элемент)
	Подключаемый_ПриИзмененииРеквизита(Элемент);
КонецПроцедуры

&НаКлиенте
Процедура КоличествоПотоковРасчетаПлановПроизводстваПриИзменении(Элемент)
	Подключаемый_ПриИзмененииРеквизита(Элемент);
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура НастроитьРасписаниеОповещенийПоБюджетнымЗадачам(Команда)
	
	Возврат; // В УТ и КА обработчик пустой
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаКлиенте
Процедура Подключаемый_ПриИзмененииРеквизита(Элемент, ОбновлятьИнтерфейс = Истина)
	
	КонстантаИмя = ПриИзмененииРеквизитаСервер(Элемент.Имя);
	
	Если ОбновлятьИнтерфейс Тогда
		ОбновитьИнтерфейс = Истина;
		ПодключитьОбработчикОжидания("ОбновитьИнтерфейсПрограммы", 2, Истина);
	КонецЕсли;
	
	Если КонстантаИмя <> "" Тогда
		Оповестить("Запись_НаборКонстант", Новый Структура, КонстантаИмя);
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ОбновитьИнтерфейсПрограммы()
	
	Если ОбновитьИнтерфейс = Истина Тогда
		ОбновитьИнтерфейс = Ложь;
		ОбщегоНазначенияКлиент.ОбновитьИнтерфейсПрограммы();
	КонецЕсли;
	
КонецПроцедуры


&НаСервере
Функция ПриИзмененииРеквизитаСервер(ИмяЭлемента)
	
	РеквизитПутьКДанным = Элементы[ИмяЭлемента].ПутьКДанным;
	
	
	КонстантаИмя = СохранитьЗначениеРеквизита(РеквизитПутьКДанным, Новый Структура);
	
	УстановитьДоступность(РеквизитПутьКДанным);
	
	ОбновитьПовторноИспользуемыеЗначения();
	
	Возврат КонстантаИмя;
	
КонецФункции

&НаСервере
Функция СохранитьЗначениеРеквизита(РеквизитПутьКДанным, Результат)
	
	// Сохранение значений реквизитов, не связанных с константами напрямую (в отношении один-к-одному).
	Если РеквизитПутьКДанным = "" Тогда
		Возврат "";
	КонецЕсли;
	
	// Определение имени константы.
	КонстантаИмя = "";
	Если СтрНачинаетсяС(НРег(РеквизитПутьКДанным), НРег("НаборКонстант.")) Тогда
		// Если путь к данным реквизита указан через "НаборКонстант".
		ЧастиИмени = СтрРазделить(РеквизитПутьКДанным, ".");
		КонстантаИмя = ЧастиИмени[1];
	Иначе
		// Определение имени и запись значения реквизита в соответствующей константе из "НаборКонстант".
		// Используется для тех реквизитов формы, которые связаны с константами напрямую (в отношении один-к-одному).
	КонецЕсли;
	
	// Сохранения значения константы.
	Если КонстантаИмя <> "" Тогда
		КонстантаМенеджер = Константы[КонстантаИмя];
		КонстантаЗначение = НаборКонстант[КонстантаИмя];
		
		Если КонстантаМенеджер.Получить() <> КонстантаЗначение Тогда
			КонстантаМенеджер.Установить(КонстантаЗначение);
		КонецЕсли;
		
		Если НастройкиСистемыПовтИсп.ЕстьПодчиненныеКонстанты(КонстантаИмя, КонстантаЗначение) Тогда
			ЭтаФорма.Прочитать();
		КонецЕсли;
		
	КонецЕсли;
	
	
	Возврат КонстантаИмя;
	
КонецФункции

&НаСервере
Процедура УстановитьДоступность(РеквизитПутьКДанным = "")
	
	ИБФайловая = ОбщегоНазначения.ИнформационнаяБазаФайловая();
	
	
	
	
	Если РеквизитПутьКДанным = "НаборКонстант.ИспользоватьТоварныеКатегории" ИЛИ РеквизитПутьКДанным = "" Тогда
		ЗначениеКонстанты = НаборКонстант.ИспользоватьТоварныеКатегории;
		Элементы.ИспользоватьПланированиеПродажПоКатегориям.Доступность = ЗначениеКонстанты;
	КонецЕсли;
	
	Если РеквизитПутьКДанным = "НаборКонстант.ИспользоватьПланированиеПродаж" 
		ИЛИ РеквизитПутьКДанным = "НаборКонстант.ИспользоватьПланированиеСборкиРазборки" 
		ИЛИ РеквизитПутьКДанным = "НаборКонстант.ИспользоватьПланированиеЗакупок" 
		ИЛИ РеквизитПутьКДанным = "НаборКонстант.ИспользоватьПланированиеВнутреннихПотреблений"
		ИЛИ РеквизитПутьКДанным = "" Тогда
		ЗначениеКонстант = НаборКонстант.ИспользоватьПланированиеПродаж
			ИЛИ НаборКонстант.ИспользоватьПланированиеСборкиРазборки
			ИЛИ НаборКонстант.ИспользоватьПланированиеЗакупок
			ИЛИ НаборКонстант.ИспользоватьПланированиеВнутреннихПотреблений;
		Элементы.ИспользоватьСезонныеКоэффициенты.Доступность = ЗначениеКонстант;
		Элементы.ПериодичностьВводаСезонныхКоэффициентов.Доступность = ЗначениеКонстант 
			И НаборКонстант.ИспользоватьСезонныеКоэффициенты;
		
		ПоказыватьКомментарийИспользоватьПланПроизводства = Ложь;
		ПоказыватьНастройкиРасчетаПланаПроизводства = Ложь;
		Элементы.ГруппаКомментарийИспользоватьПланПроизводства.Видимость = ПоказыватьКомментарийИспользоватьПланПроизводства;
		Элементы.НастройкиРасчетаПланаПроизводства.Видимость = ПоказыватьНастройкиРасчетаПланаПроизводства;
	КонецЕсли;
	
	Если РеквизитПутьКДанным = "НаборКонстант.ИспользоватьСезонныеКоэффициенты" ИЛИ РеквизитПутьКДанным = "" Тогда
		ЗначениеКонстанты = НаборКонстант.ИспользоватьСезонныеКоэффициенты;
		
		Элементы.ПериодичностьВводаСезонныхКоэффициентов.Доступность = ЗначениеКонстанты;
	КонецЕсли;
	
	Элементы.ГруппаКомментарийИспользоватьПланированиеПродажПоКатегориям.Видимость =
		НЕ Константы.ИспользоватьТоварныеКатегории.Получить();
	
	Если РеквизитПутьКДанным = "НаборКонстант.ИспользоватьСборкуРазборку" ИЛИ РеквизитПутьКДанным = "" Тогда
		ЗначениеКонстанты = НаборКонстант.ИспользоватьСборкуРазборку;
		
		Элементы.ИспользоватьПланированиеСборкиРазборки.Доступность = ЗначениеКонстанты;
		Элементы.ГруппаКомментарийИспользоватьПланированиеСборкиРазборки.Видимость = НЕ ЗначениеКонстанты;
	КонецЕсли;
	
	ОбменДаннымиУТУП.УстановитьДоступностьНастроекУзлаИнформационнойБазы(ЭтаФорма);
	
КонецПроцедуры


#КонецОбласти
