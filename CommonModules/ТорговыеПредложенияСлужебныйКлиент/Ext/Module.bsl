﻿////////////////////////////////////////////////////////////////////////////////
// Подсистема "Торговые предложения".
// ОбщийМодуль.ТорговыеПредложенияСлужебныйКлиентСервер.
////////////////////////////////////////////////////////////////////////////////
// @strict-types

#Область СлужебныйПрограммныйИнтерфейс

// Вопрос пользователю больше18 лет.
// 
// Параметры:
//  Форма - ФормаКлиентскогоПриложения
//  ОписаниеОповещенияОЗавершении - ОписаниеОповещения - будет вызвана после ответа на вопрос.
//
Процедура ПользователюБольше18Лет(Форма, ОписаниеОповещенияОЗавершении) Экспорт
	
	ПараметрыТорговыеПредложения = ПараметрыПриложенияТорговыеПредложения();
	ПользователюБольше18Лет = ПараметрыТорговыеПредложения.ПользователюБольше18Лет;
	
	Если Не ПользователюБольше18Лет.ВопросЗадан Тогда
		
		ТекстВопроса = 
			НСтр("ru = 'Нажимая ""да"", я подтверждаю, что являюсь совершеннолетним'");
		
		ПараметрыВопроса = СтандартныеПодсистемыКлиент.ПараметрыВопросаПользователю();
		ПараметрыВопроса.Заголовок = НСтр("ru = 'Предложение содержит материалы категории 18+.'");
		ПараметрыВопроса.ПредлагатьБольшеНеЗадаватьЭтотВопрос = Ложь;
		ПараметрыВопроса.БлокироватьВесьИнтерфейс = Истина;
		
		ДополнительныеПараметры = Новый Структура;
		ДополнительныеПараметры.Вставить("ОписаниеОповещенияОЗавершении", ОписаниеОповещенияОЗавершении);
		
		ИмяПроцедуры = "ПослеОтветаНаВопрос";
		ОписаниеОповещения = Новый ОписаниеОповещения(ИмяПроцедуры, ЭтотОбъект, ДополнительныеПараметры);
		
		СтандартныеПодсистемыКлиент.ПоказатьВопросПользователю(
			ОписаниеОповещения, 
			ТекстВопроса, 
			РежимДиалогаВопрос.ДаНет, 
			ПараметрыВопроса);
		
	ИначеЕсли ПользователюБольше18Лет.ВопросЗадан И ПользователюБольше18Лет.Ответ Тогда
		
		Результат = Новый Структура("Значение", КодВозвратаДиалога.Да);
		ВыполнитьОбработкуОповещения(ОписаниеОповещенияОЗавершении, Результат);
		
	Иначе
		
		Возврат;
		
	КонецЕсли;
	
КонецПроцедуры

// Имя регламентного задания синхронизация торговых предложений.
// 
// Возвращаемое значение:
//  Строка
//
Функция ИмяЗаданияСинхронизацияТорговыхПредложений() Экспорт
	Возврат НСтр("ru = 'СинхронизацияТорговыхПредложений'", ОбщегоНазначенияКлиент.КодОсновногоЯзыка());
КонецФункции

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

// Новые параметры приложения торговые предложения.
// 
// Возвращаемое значение:
//  Структура - см. НовыйПараметрыПриложенияТорговыеПредложения
//
Функция ПараметрыПриложенияТорговыеПредложения() Экспорт
	
	ИмяПараметра = "ЭлектронноеВзаимодействие.ТорговыеПредложения";
	ПараметрыПриложенияТорговыеПредложения = 
		ПараметрыПриложения[ИмяПараметра]; // см. НовыйПараметрыПриложенияТорговыеПредложения
	Если ПараметрыПриложенияТорговыеПредложения = Неопределено Тогда
		ПараметрыПриложенияТорговыеПредложения = НовыйПараметрыПриложенияТорговыеПредложения();
		ПараметрыПриложения.Вставить(ИмяПараметра, ПараметрыПриложенияТорговыеПредложения); // Соответствие
	КонецЕсли;
	
	Возврат ПараметрыПриложенияТорговыеПредложения;
	
КонецФункции

// Новые параметры приложения торговые предложения.
// 
// Возвращаемое значение:
//  Структура - Новый параметры приложения торговые предложения:
// * ПользователюБольше18Лет - Структура:
// ** ВопросЗадан - Булево - был задан вопрос о возрасте.
// ** Ответ - Булево
// * РекомендацииОтключены - Булево
//
Функция НовыйПараметрыПриложенияТорговыеПредложения()
	
	Параметры = Новый Структура;
	
	ПользователюБольше18Лет = Новый Структура("ВопросЗадан, Ответ", Ложь, Ложь);
	Параметры.Вставить("ПользователюБольше18Лет", ПользователюБольше18Лет);
	
	Параметры.Вставить("РекомендацииОтключены", Ложь);
	
	Возврат Параметры;
	
КонецФункции

// После ответа на вопрос.
// 
// Параметры:
//  Результат - Структура:
//  * Значение - Булево
//  
//  ДополнительныеПараметры - Структура:
//  * ОписаниеОповещенияОЗавершении - ОписаниеОповещения
//
Процедура ПослеОтветаНаВопрос(Результат, ДополнительныеПараметры) Экспорт
	
	Ответ = КодВозвратаДиалога.Нет;
	ПараметрыПриложенияТорговыеПредложения = ПараметрыПриложенияТорговыеПредложения();
	ПользователюБольше18Лет = ПараметрыПриложенияТорговыеПредложения.ПользователюБольше18Лет; // см. НовыйПараметрыПриложенияТорговыеПредложения
	
	Если Результат = Неопределено Тогда
		
		Возврат;
		
	ИначеЕсли Результат.Значение = КодВозвратаДиалога.Да Тогда
		
		ПользователюБольше18Лет.ВопросЗадан = Истина;
		ПользователюБольше18Лет.Ответ = Истина;
		Ответ = КодВозвратаДиалога.Да;
		
	Иначе
		
		ПользователюБольше18Лет.ВопросЗадан = Истина;
		
	КонецЕсли;
	
	Подсистема = ОбщегоНазначенияБЭДКлиентСервер.ПодсистемыБЭД().ТорговыеПредложения;
	Шаблон = НСтр("ru = 'Ответ пользователя на вопрос есть ли ему 18 лет: %1'");
	Комментарий = СтрШаблон(Шаблон, ПользователюБольше18Лет.Ответ);
	
	ЖурналРегистрацииКлиент.ДобавитьСообщениеДляЖурналаРегистрации(Подсистема, "Информация", Комментарий, , Истина);
	
	Результат = Новый Структура("Значение", Ответ);
	ВыполнитьОбработкуОповещения(ДополнительныеПараметры.ОписаниеОповещенияОЗавершении, Результат);
	
КонецПроцедуры

// Новый параметры предложения.
// 
// Возвращаемое значение:
//  Структура:
// * ИдентификаторПредложения - Строка
// * Количество - Число
// * Наименование - Строка
//
Функция НовыйПараметрыПредложения() Экспорт
	
	Результат = Новый Структура;
	Результат.Вставить("ИдентификаторПредложения", "");
	Результат.Вставить("Количество", 0);
	Результат.Вставить("Наименование", "");
	
	Возврат Результат;
	
КонецФункции

// Описание параметров запроса trade-offers/storefront/product-offers.
// Описание всех параметров по ссылке: "http://dev.legacy-api.dev.dept07/#/specs/trade-offers-searcher-api.yaml".
// 
// Возвращаемое значение:
//  Структура - Новый параметры запроса характеристик категорий:
// * ИдентификаторКатегории - Строка - Идентификатор категории рубрикатора
// * ВНаличии - Булево - Если задано значение true, то в результат выборки товаров не будут включены предложения поставщиков, где товара нет на складе или уровень складских остатков не задан. Если не указано или значение false то критерий не применяется.
// * ТорговыеМарки - Массив из Строка- Список торговых марок
// * ЦенаОт - Число - Цена торговых предложений за единицу товара, от (копейки)
// * ЦенаДо - Число - Цена торговых предложений за единицу товара, до (копейки)
// * Контрагенты - Массив из ОпределяемыйТип.КонтрагентБЭД - Список идентификаторов поставщиков
// * СИзображением - Булево - Возвращать только те предложения, где для товара есть изображения. Если указано, и значение true, то выбираются только те ТП, которые имеют изображение. Если не указано или значение false то критерий не применяется.
// * СоСкидкой - Булево - Если задано значение true, то в результат выборки товаров не будут включены предложения поставщиков, для которых не предлагается скидки. Если не указано или значение false то критерий игнорируется.
// * РегионыПоиска - Массив из Структура
//
Функция НовыйПараметрыЗапросаХарактеристикКатегорий() Экспорт
	
	Результат = Новый Структура;
	Результат.Вставить("ИдентификаторКатегории", "");
	Результат.Вставить("ВНаличии",    Ложь);
	Результат.Вставить("ТорговыеМарки", Новый Массив);
	Результат.Вставить("ЦенаОт", 0);
	Результат.Вставить("ЦенаДо", 0);
	Результат.Вставить("Контрагенты", Новый Массив);
	Результат.Вставить("СИзображением", Ложь);
	Результат.Вставить("СоСкидкой", Ложь);
	Результат.Вставить("РегионыПоиска", Новый Массив);
	
	Возврат Результат;
	
КонецФункции

#КонецОбласти