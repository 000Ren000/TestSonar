﻿
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
		
	// Выгрузка электронных документов.
	МассивСсылокНаОбъект = Новый Массив;
	Если Параметры.Свойство("СтруктураЭД", МассивСсылокНаОбъект) Тогда
		Если МассивСсылокНаОбъект.Количество() = 0 Тогда
			Отказ = Истина;
			Возврат;
		КонецЕсли;
		
		ПараметрыЗадания = Новый Структура;
		ПараметрыЗадания.Вставить("МассивСсылокНаОбъект", МассивСсылокНаОбъект);
		ПараметрыЗадания.Вставить("ОтправкаЧерезБС", Ложь);
		
		АдресХранилища = ПоместитьВоВременноеХранилище(Неопределено, УникальныйИдентификатор);
		
		РезультатПроверкиГотовности = ИнтеграцияЭДО.ПроверкаГотовностиКДокументообороту(МассивСсылокНаОбъект);
		
		Если РезультатПроверкиГотовности.Неготовые.Количество() > 0 Тогда
			Возврат;
		КонецЕсли;
		
		СинхронизацияЭДО.ОбновитьКешиОператоровЭДОИФорматов();

		РезультатФормирования = ИнтерфейсДокументовЭДО.ПодготовитьДанныеДляЗаполненияДокументов(ПараметрыЗадания);

		Если ЗначениеЗаполнено(РезультатФормирования.ТаблицаЭД) Тогда
			АдресХранилища = ПоместитьВоВременноеХранилище(РезультатФормирования.ТаблицаЭД, УникальныйИдентификатор);
		Иначе
			Отказ = Истина;
			ОбщегоНазначения.СообщитьПользователю(РезультатФормирования.ТекстОшибки);
			Возврат;
		КонецЕсли;

		ЗагрузитьПодготовленныеДанныеЭД();
		
	КонецЕсли;	

КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	
	Если ЗначениеЗаполнено(Ошибки) Тогда
		
		ПараметрыОбработки = ИнтерфейсДокументовЭДОКлиентСервер.НовыеПараметрыПроблемПриОбработкеДокументов();
		ПараметрыОбработки.ФормаВладелец = ЭтотОбъект.ВладелецФормы;
		ДанныеОшибки = ПолучитьИзВременногоХранилища(Ошибки);
		
		СтруктураОшибки = Новый Структура("ОписаниеОбъектаУчета, ОшибкиДанных", ДанныеОшибки.ОписаниеОбъектаУчета, ДанныеОшибки.Ошибки);
		ОшибкиФормирования = Новый Массив;
		ОшибкиФормирования.Добавить(СтруктураОшибки);
		
		ПараметрыОбработки.АдресСведенийОбОшибках = ПоместитьВоВременноеХранилище(ОшибкиФормирования, УникальныйИдентификатор);
		
		ИнтерфейсДокументовЭДОКлиент.ПоказатьПроблемыПриОбработкеДокументов(Неопределено, ПараметрыОбработки);
		
		Отказ = Истина;
		Возврат;
	КонецЕсли;
	
	Если Не ЗначениеЗаполнено(ТаблицаДанных) Тогда
		Отказ = Истина;
		Возврат;
	КонецЕсли;
	
	ИзменитьВидимостьДоступность();
	
	ОбработкаНеисправностейБЭДКлиент.ОбработатьОшибки(КонтекстОперации);
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура СпособВыгрузкиПриИзменении(Элемент)
	
	ИзменитьСпособВыгрузки();
	ИзменитьВидимостьДоступность();
	Модифицированность = Ложь;
	
КонецПроцедуры

&НаКлиенте
Процедура ПросмотрДокументовНажатие(Элемент)
	
	Если ТаблицаДанных.Количество() > 1 Тогда
		МассивСтруктур = Новый Массив;
		Для Каждого СтрокаДанных Из ТаблицаДанных Цикл
			СтруктураПараметров =  ИнтерфейсДокументовЭДОКлиент.НовыеПараметрыФормыПросмотраЗагрузкиЭлектронныхДокументов();;
			ЗаполнитьЗначенияСвойств(СтруктураПараметров, СтрокаДанных);
			
			МассивСтруктур.Добавить(СтруктураПараметров);
		КонецЦикла;
		
		ОткрытьФорму("Обработка.ИнтерфейсДокументовЭДО.Форма.СписокВыгружаемыхЭлектронныхДокументов",
			Новый Структура("СтруктураЭД", МассивСтруктур), ЭтотОбъект);
	ИначеЕсли ТаблицаДанных.Количество() = 1 Тогда
		ВывестиЭДНаПросмотр(ТаблицаДанных[0]);
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура ВыполнитьДействие(Команда)
	
	ОчиститьСообщения();
	
	ТекстСообщения = "";
	Отказ = ВыгрузитьЭД(ТекстСообщения);
	
	Если Отказ Тогда
		ОбщегоНазначенияКлиент.СообщитьПользователю(ТекстСообщения);
	Иначе
		Закрыть();
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаКлиенте
Процедура ИзменитьВидимостьДоступность()
	
	ВыгрузкаВЭП = (СпособВыгрузки = "ЧерезЭлектроннуюПочту");
	Элементы.СтраницыПолучателей.Доступность = ВыгрузкаВЭП ИЛИ (Элементы.СтраницыПолучателей.ТекущаяСтраница = Элементы.НетДоступа);
	
КонецПроцедуры

&НаСервере
Процедура ИзменитьВидимостьДоступностьПриСозданииНаСервере()
	
	Текст = НСтр("ru = 'Выгрузка документов в файл'");
	ТекстГиперссылки = НСтр("ru = 'Документы не найдены.'");
	Если ТаблицаДанных.Количество() > 1 Тогда
		ТекстГиперссылки = НСтр("ru = 'Открыть список электронных документов (%1)'");
		ТекстГиперссылки = СтрЗаменить(ТекстГиперссылки, "%1", ТаблицаДанных.Количество());
	ИначеЕсли ТаблицаДанных.Количество() = 1 Тогда
		ТекстГиперссылки = НСтр("ru = 'Электронный документ: %1'");
		ТекстГиперссылки = СтрЗаменить(ТекстГиперссылки, "%1", ТаблицаДанных[0].ИмяФайла);
	КонецЕсли;
	Элементы.ПредварительныйПросмотрДокумента.Заголовок = ТекстГиперссылки;
	Заголовок = Текст;
	СпособВыгрузки = "ЧерезЭлектроннуюПочту";
	
	Если Не ПравоДоступа("Чтение", Метаданные.Справочники.УчетныеЗаписиЭлектроннойПочты) Тогда
		СпособВыгрузки = "ЧерезКаталог";
		Элементы.СтраницыПолучателей.ТекущаяСтраница = Элементы.НетДоступа;
		Элементы.СпособВыгрузки.Доступность = Ложь;
	Иначе
		ИзменитьСпособВыгрузки();
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ВывестиЭДНаПросмотр(СтрокаДанных)
	
	СтруктураПараметров = ИнтерфейсДокументовЭДОКлиент.НовыеПараметрыФормыПросмотраЗагрузкиЭлектронныхДокументов();
	ЗаполнитьЗначенияСвойств(СтруктураПараметров, СтрокаДанных);
	
	ИнтерфейсДокументовЭДОКлиент.ОткрытьФормуПросмотраЗагрузкиЭлектронногоДокумента(СтруктураПараметров);
	
КонецПроцедуры

&НаСервере
Функция ПолучитьУчетнуюЗапись()
	
	ДоступныеУчетныеЗаписи = РаботаСПочтовымиСообщениями.ДоступныеУчетныеЗаписи(Истина);
	
	Если ЗначениеЗаполнено(ДоступныеУчетныеЗаписи) Тогда
		Возврат ДоступныеУчетныеЗаписи.Ссылка;
	КонецЕсли;
	
	Возврат Справочники.УчетныеЗаписиЭлектроннойПочты.ПустаяСсылка();

КонецФункции

&НаКлиенте
Функция ВыгрузитьЭД(ТекстСообщения)
	
	Отказ = Ложь;
	Если НЕ ЗначениеЗаполнено(СпособВыгрузки) Тогда
		ТекстСообщения = НСтр("ru = 'Необходимо указать способ выгрузки.'");
		Отказ = Истина;
	КонецЕсли;
	Если СпособВыгрузки = "ЧерезЭлектроннуюПочту"
		И НЕ ЗначениеЗаполнено(УчетнаяЗапись) Тогда
		ТекстСообщения = ТекстСообщения + ?(ЗначениеЗаполнено(ТекстСообщения), Символы.ПС, "")
			+ НСтр("ru = 'Необходимо указать учетную запись.'");
		Отказ = Истина;
	КонецЕсли;
	Если НЕ Отказ Тогда
		СтруктураПараметров = Новый Структура;
		СтруктураПараметров.Вставить("СпособВыгрузки",  СпособВыгрузки);
		СтруктураПараметров.Вставить("ПутьККаталогу");
		СтруктураПараметров.Вставить("УчетнаяЗапись",   УчетнаяЗапись);
		СтруктураПараметров.Вставить("АдресПолучателя", АдресПолучателя);
		
		МассивСтруктур = Новый Массив;
		
		Для Каждого СтрокаДанных Из ТаблицаДанных Цикл
			СтруктураОбмена = Новый Структура;

			СтруктураОбмена.Вставить("НаименованиеФайла", СтрокаДанных.ПолноеИмяФайла);
			СтруктураОбмена.Вставить("НаправлениеЭД",     СтрокаДанных.НаправлениеЭД);
			СтруктураОбмена.Вставить("Контрагент",        СтрокаДанных.Контрагент);
			СтруктураОбмена.Вставить("АдресХранилища",    СтрокаДанных.АдресХранилищаПакета);
			
			МассивСтруктур.Добавить(СтруктураОбмена);
		КонецЦикла;
		
		БыстрыйОбменВыгрузитьЭД(МассивСтруктур, СтруктураПараметров);
	КонецЕсли;
	
	Возврат Отказ;
	
КонецФункции

&НаСервере
Процедура ИзменитьСпособВыгрузки()
	
	Если СпособВыгрузки = Перечисления.СпособыОбменаЭД.ЧерезЭлектроннуюПочту Тогда
		Если ЗначениеЗаполнено(Контрагент) И Не ЗначениеЗаполнено(АдресПолучателя) Тогда
			АдресПолучателя = ""; 
			ИнтеграцияЭДО.АдресЭлектроннойПочтыКонтрагента(Контрагент, АдресПолучателя);
		КонецЕсли;
		Если Не ЗначениеЗаполнено(УчетнаяЗапись) Тогда
			УчетнаяЗапись = ПолучитьУчетнуюЗапись();
		КонецЕсли;
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура БыстрыйОбменВыгрузитьЭД(МассивСтруктурОбмена, СтруктураПараметров)
	
	Если СтруктураПараметров.СпособВыгрузки = "ЧерезКаталог" Тогда
		МассивФайлов = Новый Массив;
		Для Каждого СтруктураОбмена Из МассивСтруктурОбмена Цикл
			ОписаниеФайла = Новый ОписаниеПередаваемогоФайла(
				СтруктураОбмена.НаименованиеФайла + ".zip", СтруктураОбмена.АдресХранилища);
			МассивФайлов.Добавить(ОписаниеФайла);
		КонецЦикла;
		Заголовок = НСтр("ru = 'Выберите каталог для сохранения файлов'");
		ПараметрыДиалога = Новый ПараметрыДиалогаПолученияФайлов(Заголовок, Истина);
		НачатьПолучениеФайловССервера(МассивФайлов, ПараметрыДиалога);
	Иначе
		ПараметрыФормы = Новый Структура;
		Если МассивСтруктурОбмена.Количество() > 1 Тогда
			ТемаПисьма = НСтр("ru = 'Пакеты электронных документов'");
		Иначе
			ТемаПисьма = НСтр("ru = 'Пакет электронного документа:'") + " " + МассивСтруктурОбмена[0].НаименованиеФайла;
		КонецЕсли;
		ПараметрыФормы.Вставить("Тема", ТемаПисьма);
		ПараметрыФормы.Вставить("УчетнаяЗапись", СтруктураПараметров.УчетнаяЗапись);
		ПараметрыФормы.Вставить("Получатель", СтруктураПараметров.АдресПолучателя);
		
		Вложения = Новый Массив;
		Для Каждого СтруктураОбмена Из МассивСтруктурОбмена Цикл
			ДанныеВложения = Новый Структура();
			ДанныеВложения.Вставить("Представление", СтруктураОбмена.НаименованиеФайла + ".zip");
			ДанныеВложения.Вставить("АдресВоВременномХранилище", СтруктураОбмена.АдресХранилища);
			Вложения.Добавить(ДанныеВложения);
		КонецЦикла;
		ПараметрыФормы.Вставить("Вложения", Вложения);
		ОткрытьФорму("ОбщаяФорма.ОтправкаСообщения", ПараметрыФормы);
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура ЗагрузитьПодготовленныеДанныеЭД()
	
	ТаблицаЭД = ПолучитьИзВременногоХранилища(АдресХранилища);
	
	ТаблицаЭД.Колонки.Добавить("АдресХранилищаПакета");
	ТаблицаЭД.Колонки.Добавить("АдресХранилищаФайла");
	ТаблицаЭД.Колонки.Добавить("УникальныйИдентификатор");
	
	Если НЕ ЗначениеЗаполнено(ТаблицаЭД) Тогда
		Возврат;
	КонецЕсли;
	
	Для каждого Строка Из ТаблицаЭД Цикл
		Строка.АдресХранилищаПакета = ПоместитьВоВременноеХранилище(Строка.ДвоичныеДанныеПакета, УникальныйИдентификатор);
		Строка.АдресХранилищаФайла = ПоместитьВоВременноеХранилище(Строка.ДвоичныеДанныеФайла, УникальныйИдентификатор);
		Если Не ЗначениеЗаполнено(Строка.УникальныйИдентификатор) Тогда
			Строка.УникальныйИдентификатор = Строка(Новый УникальныйИдентификатор());
		КонецЕсли;
	КонецЦикла;
	
	ТаблицаДанных.Загрузить(ТаблицаЭД);
	
	ИзменитьВидимостьДоступностьПриСозданииНаСервере();
	
КонецПроцедуры

#КонецОбласти
